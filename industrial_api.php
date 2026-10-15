<?php
// ============================================================
//  Smart Production Industrial Services – Backend API
//  Handles: NUP, Tagihan/Invoice, BAL, BAST, Workshop Jobs, ATPA, Pengeluaran & Summary
// ============================================================

require_once __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Api-Key');

$reqMethod = $_SERVER['REQUEST_METHOD'] ?? 'GET';
if ($reqMethod === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Cek API Key (optional check or matches config)
$sentKey = '';
if (function_exists('getallheaders')) {
    $headers = getallheaders();
    $sentKey = $headers['X-Api-Key'] ?? $headers['x-api-key'] ?? '';
}
if (empty($sentKey)) {
    $sentKey = $_GET['key'] ?? '';
}
if (defined('API_SECRET') && !empty($sentKey) && !hash_equals(API_SECRET, $sentKey)) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$db = getDb();
$action = $_GET['action'] ?? '';
$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

try {
    switch ($action) {

        // ─────────────────────────────────────────────
        // 1. DASHBOARD EXECUTIVE SUMMARY
        // ─────────────────────────────────────────────
        case 'summary':
            // Total NUP
            $totalNup = $db->query("SELECT COUNT(*) FROM nup")->fetchColumn() ?: 0;
            $nupAktif = $db->query("SELECT COUNT(*) FROM nup WHERE status = 'aktif'")->fetchColumn() ?: 0;
            $totalKontrak = $db->query("SELECT COALESCE(SUM(nilai_kontrak),0) FROM nup WHERE status != 'batal'")->fetchColumn() ?: 0;

            // Tagihan
            $totalTagihan = $db->query("SELECT COALESCE(SUM(nilai),0) FROM tagihan WHERE status != 'batal'")->fetchColumn() ?: 0;
            $tagihanLunas = $db->query("SELECT COALESCE(SUM(nilai),0) FROM tagihan WHERE status = 'lunas'")->fetchColumn() ?: 0;
            $tagihanPending = $totalTagihan - $tagihanLunas;

            // Pengeluaran
            $totalPengeluaran = $db->query("SELECT COALESCE(SUM(nilai),0) FROM pengeluaran")->fetchColumn() ?: 0;
            $pengeluaranPo = $db->query("SELECT COALESCE(SUM(nilai),0) FROM pengeluaran WHERE jenis = 'po'")->fetchColumn() ?: 0;
            $pengeluaranUnik = $db->query("SELECT COALESCE(SUM(nilai),0) FROM pengeluaran WHERE jenis = 'unik'")->fetchColumn() ?: 0;

            // Margin & Workshop
            $margin = $totalKontrak - $totalPengeluaran;
            $totalJob = $db->query("SELECT COUNT(*) FROM workshop_job")->fetchColumn() ?: 0;
            $jobLate = $db->query("SELECT COUNT(*) FROM workshop_job WHERE is_late = 1 OR (status != 'selesai' AND tgl_plan_selesai < CURDATE())")->fetchColumn() ?: 0;
            $totalAtpa = $db->query("SELECT COUNT(*) FROM atpa")->fetchColumn() ?: 0;

            // NUP list with calculated metrics
            $nupList = $db->query("
                SELECT n.*,
                    COALESCE((SELECT SUM(t.nilai) FROM tagihan t WHERE t.nup_id = n.id AND t.status != 'batal'), 0) AS sum_tagihan,
                    COALESCE((SELECT SUM(t.nilai) FROM tagihan t WHERE t.nup_id = n.id AND t.status = 'lunas'), 0) AS sum_tagihan_lunas,
                    COALESCE((SELECT SUM(p.nilai) FROM pengeluaran p WHERE p.nup_id = n.id), 0) AS sum_pengeluaran,
                    COALESCE((SELECT COUNT(*) FROM workshop_job w WHERE w.nup_id = n.id), 0) AS total_job,
                    COALESCE((SELECT COUNT(*) FROM workshop_job w WHERE w.nup_id = n.id AND (w.is_late = 1 OR (w.status != 'selesai' AND w.tgl_plan_selesai < CURDATE()))), 0) AS job_late
                FROM nup n
                ORDER BY n.id DESC
            ")->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode([
                'ok' => true,
                'stats' => [
                    'totalNup' => (int)$totalNup,
                    'nupAktif' => (int)$nupAktif,
                    'totalKontrak' => (float)$totalKontrak,
                    'totalTagihan' => (float)$totalTagihan,
                    'tagihanLunas' => (float)$tagihanLunas,
                    'tagihanPending' => (float)$tagihanPending,
                    'totalPengeluaran' => (float)$totalPengeluaran,
                    'pengeluaranPo' => (float)$pengeluaranPo,
                    'pengeluaranUnik' => (float)$pengeluaranUnik,
                    'margin' => (float)$margin,
                    'totalJob' => (int)$totalJob,
                    'jobLate' => (int)$jobLate,
                    'totalAtpa' => (int)$totalAtpa,
                ],
                'nups' => $nupList
            ]);
            break;

        // ─────────────────────────────────────────────
        // 2. NUP (Nomor Urut Pekerjaan)
        // ─────────────────────────────────────────────
        case 'get_nups':
            $stmt = $db->query("SELECT * FROM nup ORDER BY id DESC");
            echo json_encode(['ok' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
            break;

        case 'save_nup':
            $id = $input['id'] ?? null;
            $nup_number = trim($input['nup_number'] ?? '');
            $customer = trim($input['customer'] ?? '');
            $description = $input['description'] ?? '';
            $area = $input['area'] ?? '';
            $nilai_kontrak = (float)($input['nilai_kontrak'] ?? 0);
            $tgl_mulai = !empty($input['tgl_mulai']) ? $input['tgl_mulai'] : null;
            $tgl_selesai = !empty($input['tgl_selesai']) ? $input['tgl_selesai'] : null;
            $status = $input['status'] ?? 'aktif';
            $catatan = $input['catatan'] ?? '';

            if (empty($nup_number) || empty($customer)) {
                http_response_code(400);
                echo json_encode(['error' => 'Nomor NUP dan Customer wajib diisi']);
                exit;
            }

            if ($id) {
                $stmt = $db->prepare("UPDATE nup SET nup_number=?, customer=?, description=?, area=?, nilai_kontrak=?, tgl_mulai=?, tgl_selesai=?, status=?, catatan=? WHERE id=?");
                $stmt->execute([$nup_number, $customer, $description, $area, $nilai_kontrak, $tgl_mulai, $tgl_selesai, $status, $catatan, $id]);
            } else {
                $stmt = $db->prepare("INSERT INTO nup (nup_number, customer, description, area, nilai_kontrak, tgl_mulai, tgl_selesai, status, catatan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nup_number, $customer, $description, $area, $nilai_kontrak, $tgl_mulai, $tgl_selesai, $status, $catatan]);
                $id = $db->lastInsertId();
            }
            echo json_encode(['ok' => true, 'id' => $id, 'message' => 'NUP berhasil disimpan']);
            break;

        case 'delete_nup':
            $id = (int)($input['id'] ?? $_GET['id'] ?? 0);
            if ($id) {
                $db->prepare("DELETE FROM nup WHERE id = ?")->execute([$id]);
            }
            echo json_encode(['ok' => true]);
            break;

        // ─────────────────────────────────────────────
        // 3. TAGIHAN / INVOICE TRACKING
        // ─────────────────────────────────────────────
        case 'get_tagihan':
            $nupId = $_GET['nup_id'] ?? null;
            $sql = "SELECT t.*, n.nup_number, n.customer,
                    b.no_bal, b.tgl_bal,
                    bs.no_bast, bs.tgl_bast, bs.status AS status_bast
                    FROM tagihan t
                    JOIN nup n ON t.nup_id = n.id
                    LEFT JOIN bal b ON b.tagihan_id = t.id
                    LEFT JOIN bast bs ON bs.tagihan_id = t.id";
            if ($nupId) {
                $sql .= " WHERE t.nup_id = ? ORDER BY t.id DESC";
                $stmt = $db->prepare($sql);
                $stmt->execute([$nupId]);
            } else {
                $sql .= " ORDER BY t.id DESC";
                $stmt = $db->query($sql);
            }
            echo json_encode(['ok' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
            break;

        case 'save_tagihan':
            $id = $input['id'] ?? null;
            $nup_id = (int)($input['nup_id'] ?? 0);
            $no_tagihan = trim($input['no_tagihan'] ?? '');
            $pekerjaan = trim($input['pekerjaan'] ?? '');
            $area = $input['area'] ?? '';
            $nilai = (float)($input['nilai'] ?? 0);
            $tgl_tagihan = !empty($input['tgl_tagihan']) ? $input['tgl_tagihan'] : null;
            $status = $input['status'] ?? 'draft';
            $remark = $input['remark'] ?? '';
            $created_by = $input['created_by'] ?? 'Admin';

            if (empty($nup_id) || empty($no_tagihan) || empty($pekerjaan)) {
                http_response_code(400);
                echo json_encode(['error' => 'Pilih NUP, Nomor Tagihan, dan Uraian Pekerjaan']);
                exit;
            }

            if ($id) {
                $stmt = $db->prepare("UPDATE tagihan SET nup_id=?, no_tagihan=?, pekerjaan=?, area=?, nilai=?, tgl_tagihan=?, status=?, remark=?, created_by=? WHERE id=?");
                $stmt->execute([$nup_id, $no_tagihan, $pekerjaan, $area, $nilai, $tgl_tagihan, $status, $remark, $created_by, $id]);
            } else {
                $stmt = $db->prepare("INSERT INTO tagihan (nup_id, no_tagihan, pekerjaan, area, nilai, tgl_tagihan, status, remark, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nup_id, $no_tagihan, $pekerjaan, $area, $nilai, $tgl_tagihan, $status, $remark, $created_by]);
                $id = $db->lastInsertId();
            }
            echo json_encode(['ok' => true, 'id' => $id, 'message' => 'Tagihan berhasil disimpan']);
            break;

        case 'update_tagihan_status':
            $id = (int)($input['id'] ?? 0);
            $status = $input['status'] ?? 'draft';
            if ($id) {
                $stmt = $db->prepare("UPDATE tagihan SET status = ? WHERE id = ?");
                $stmt->execute([$status, $id]);
            }
            echo json_encode(['ok' => true]);
            break;

        case 'delete_tagihan':
            $id = (int)($input['id'] ?? $_GET['id'] ?? 0);
            if ($id) {
                $db->prepare("DELETE FROM tagihan WHERE id = ?")->execute([$id]);
            }
            echo json_encode(['ok' => true]);
            break;

        // ─────────────────────────────────────────────
        // 4. BAL (Berita Acara Lapangan) & BAST
        // ─────────────────────────────────────────────
        case 'save_bal':
            $tagihan_id = (int)($input['tagihan_id'] ?? 0);
            $no_bal = trim($input['no_bal'] ?? '');
            $tgl_bal = !empty($input['tgl_bal']) ? $input['tgl_bal'] : date('Y-m-d');
            $diterima_oleh = $input['diterima_oleh'] ?? '';
            $catatan = $input['catatan'] ?? '';

            if (!$tagihan_id || empty($no_bal)) {
                http_response_code(400);
                echo json_encode(['error' => 'Tagihan dan No BAL wajib diisi']);
                exit;
            }

            // Insert or update
            $exists = $db->prepare("SELECT id FROM bal WHERE tagihan_id = ?");
            $exists->execute([$tagihan_id]);
            $balId = $exists->fetchColumn();

            if ($balId) {
                $db->prepare("UPDATE bal SET no_bal=?, tgl_bal=?, diterima_oleh=?, catatan=? WHERE id=?")->execute([$no_bal, $tgl_bal, $diterima_oleh, $catatan, $balId]);
            } else {
                $db->prepare("INSERT INTO bal (tagihan_id, no_bal, tgl_bal, diterima_oleh, catatan) VALUES (?, ?, ?, ?, ?)")->execute([$tagihan_id, $no_bal, $tgl_bal, $diterima_oleh, $catatan]);
                $balId = $db->lastInsertId();
            }

            // Otomatis update status tagihan jadi 'bal'
            $db->prepare("UPDATE tagihan SET status = 'bal' WHERE id = ? AND status IN ('draft', 'dikirim')")->execute([$tagihan_id]);

            echo json_encode(['ok' => true, 'id' => $balId, 'message' => 'Dokumen BAL berhasil disimpan']);
            break;

        case 'save_bast':
            $tagihan_id = (int)($input['tagihan_id'] ?? 0);
            $no_bast = trim($input['no_bast'] ?? '');
            $tgl_bast = !empty($input['tgl_bast']) ? $input['tgl_bast'] : date('Y-m-d');
            $nilai_bast = (float)($input['nilai_bast'] ?? 0);
            $penerima = $input['penerima'] ?? '';
            $jabatan = $input['jabatan'] ?? '';
            $status_bast = $input['status'] ?? 'draft';
            $catatan = $input['catatan'] ?? '';

            if (!$tagihan_id || empty($no_bast)) {
                http_response_code(400);
                echo json_encode(['error' => 'Tagihan dan No BAST wajib diisi']);
                exit;
            }

            $exists = $db->prepare("SELECT id FROM bast WHERE tagihan_id = ?");
            $exists->execute([$tagihan_id]);
            $bastId = $exists->fetchColumn();

            if ($bastId) {
                $db->prepare("UPDATE bast SET no_bast=?, tgl_bast=?, nilai_bast=?, penerima=?, jabatan=?, status=?, catatan=? WHERE id=?")->execute([$no_bast, $tgl_bast, $nilai_bast, $penerima, $jabatan, $status_bast, $catatan, $bastId]);
            } else {
                $balId = $db->query("SELECT id FROM bal WHERE tagihan_id = $tagihan_id LIMIT 1")->fetchColumn() ?: null;
                $db->prepare("INSERT INTO bast (tagihan_id, bal_id, no_bast, tgl_bast, nilai_bast, penerima, jabatan, status, catatan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")->execute([$tagihan_id, $balId, $no_bast, $tgl_bast, $nilai_bast, $penerima, $jabatan, $status_bast, $catatan]);
                $bastId = $db->lastInsertId();
            }

            // Update status tagihan jadi 'bast'
            $db->prepare("UPDATE tagihan SET status = 'bast' WHERE id = ? AND status != 'lunas'")->execute([$tagihan_id]);

            echo json_encode(['ok' => true, 'id' => $bastId, 'message' => 'Dokumen BAST berhasil disimpan']);
            break;

        // ─────────────────────────────────────────────
        // 5. WORKSHOP JOBS & LATE SCHEDULE
        // ─────────────────────────────────────────────
        case 'get_workshop_jobs':
            $nupId = $_GET['nup_id'] ?? null;
            $sql = "SELECT w.*, n.nup_number, n.customer,
                    CASE
                        WHEN w.status != 'selesai' AND w.tgl_plan_selesai < CURDATE() THEN 1
                        ELSE w.is_late
                    END AS calculated_late
                    FROM workshop_job w
                    JOIN nup n ON w.nup_id = n.id";
            if ($nupId) {
                $sql .= " WHERE w.nup_id = ? ORDER BY w.id DESC";
                $stmt = $db->prepare($sql);
                $stmt->execute([$nupId]);
            } else {
                $sql .= " ORDER BY calculated_late DESC, w.id DESC";
                $stmt = $db->query($sql);
            }
            echo json_encode(['ok' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
            break;

        case 'save_workshop_job':
            $id = $input['id'] ?? null;
            $nup_id = (int)($input['nup_id'] ?? 0);
            $nama_pekerjaan = trim($input['nama_pekerjaan'] ?? '');
            $area = $input['area'] ?? '';
            $tgl_plan_mulai = !empty($input['tgl_plan_mulai']) ? $input['tgl_plan_mulai'] : null;
            $tgl_plan_selesai = !empty($input['tgl_plan_selesai']) ? $input['tgl_plan_selesai'] : null;
            $progress_pct = (int)($input['progress_pct'] ?? 0);
            $status = $input['status'] ?? 'belum_mulai';
            $dp_dibayar = (int)($input['dp_dibayar'] ?? 0);
            $manpower_dibutuhkan = (int)($input['manpower_dibutuhkan'] ?? 0);
            $manpower_tersedia = (int)($input['manpower_tersedia'] ?? 0);
            $is_late = (int)($input['is_late'] ?? 0);
            $alasan_keterlambatan = $input['alasan_keterlambatan'] ?? null;
            $remark = $input['remark'] ?? null;

            if (!$nup_id || empty($nama_pekerjaan)) {
                http_response_code(400);
                echo json_encode(['error' => 'NUP dan Nama Pekerjaan wajib diisi']);
                exit;
            }

            if ($id) {
                $stmt = $db->prepare("UPDATE workshop_job SET nup_id=?, nama_pekerjaan=?, area=?, tgl_plan_mulai=?, tgl_plan_selesai=?, progress_pct=?, status=?, dp_dibayar=?, manpower_dibutuhkan=?, manpower_tersedia=?, is_late=?, alasan_keterlambatan=?, remark=? WHERE id=?");
                $stmt->execute([$nup_id, $nama_pekerjaan, $area, $tgl_plan_mulai, $tgl_plan_selesai, $progress_pct, $status, $dp_dibayar, $manpower_dibutuhkan, $manpower_tersedia, $is_late, $alasan_keterlambatan, $remark, $id]);
            } else {
                $stmt = $db->prepare("INSERT INTO workshop_job (nup_id, nama_pekerjaan, area, tgl_plan_mulai, tgl_plan_selesai, progress_pct, status, dp_dibayar, manpower_dibutuhkan, manpower_tersedia, is_late, alasan_keterlambatan, remark) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nup_id, $nama_pekerjaan, $area, $tgl_plan_mulai, $tgl_plan_selesai, $progress_pct, $status, $dp_dibayar, $manpower_dibutuhkan, $manpower_tersedia, $is_late, $alasan_keterlambatan, $remark]);
                $id = $db->lastInsertId();
            }
            echo json_encode(['ok' => true, 'id' => $id, 'message' => 'Pekerjaan workshop tersimpan']);
            break;

        case 'update_late_schedule':
            $id = (int)($input['id'] ?? 0);
            $new_plan_selesai = $input['tgl_plan_selesai'] ?? null;
            $alasan = $input['alasan_keterlambatan'] ?? '';
            $is_late = (int)($input['is_late'] ?? 1);
            if ($id) {
                $stmt = $db->prepare("UPDATE workshop_job SET tgl_plan_selesai=?, alasan_keterlambatan=?, is_late=? WHERE id=?");
                $stmt->execute([$new_plan_selesai, $alasan, $is_late, $id]);
            }
            echo json_encode(['ok' => true, 'message' => 'Jadwal berhasil dimodifikasi']);
            break;

        case 'delete_workshop_job':
            $id = (int)($input['id'] ?? $_GET['id'] ?? 0);
            if ($id) {
                $db->prepare("DELETE FROM workshop_job WHERE id = ?")->execute([$id]);
            }
            echo json_encode(['ok' => true]);
            break;

        // ─────────────────────────────────────────────
        // 6. ATPA
        // ─────────────────────────────────────────────
        case 'get_atpa':
            $stmt = $db->query("SELECT a.*, n.nup_number, n.customer FROM atpa a JOIN nup n ON a.nup_id = n.id ORDER BY a.id DESC");
            echo json_encode(['ok' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
            break;

        case 'save_atpa':
            $id = $input['id'] ?? null;
            $nup_id = (int)($input['nup_id'] ?? 0);
            $no_atpa = trim($input['no_atpa'] ?? '');
            $tgl_atpa = !empty($input['tgl_atpa']) ? $input['tgl_atpa'] : date('Y-m-d');
            $item = trim($input['item'] ?? '');
            $nilai = (float)($input['nilai'] ?? 0);
            $status = $input['status'] ?? 'open';
            $pic = $input['pic'] ?? '';
            $catatan = $input['catatan'] ?? '';

            if (!$nup_id || empty($no_atpa) || empty($item)) {
                http_response_code(400);
                echo json_encode(['error' => 'Pilih NUP, No ATPA, dan Nama Item']);
                exit;
            }

            if ($id) {
                $stmt = $db->prepare("UPDATE atpa SET nup_id=?, no_atpa=?, tgl_atpa=?, item=?, nilai=?, status=?, pic=?, catatan=? WHERE id=?");
                $stmt->execute([$nup_id, $no_atpa, $tgl_atpa, $item, $nilai, $status, $pic, $catatan, $id]);
            } else {
                $stmt = $db->prepare("INSERT INTO atpa (nup_id, no_atpa, tgl_atpa, item, nilai, status, pic, catatan) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nup_id, $no_atpa, $tgl_atpa, $item, $nilai, $status, $pic, $catatan]);
                $id = $db->lastInsertId();
            }
            echo json_encode(['ok' => true, 'id' => $id, 'message' => 'ATPA tersimpan']);
            break;

        case 'delete_atpa':
            $id = (int)($input['id'] ?? $_GET['id'] ?? 0);
            if ($id) {
                $db->prepare("DELETE FROM atpa WHERE id = ?")->execute([$id]);
            }
            echo json_encode(['ok' => true]);
            break;

        // ─────────────────────────────────────────────
        // 7. PENGELUARAN (PO & UNIK)
        // ─────────────────────────────────────────────
        case 'get_pengeluaran':
            $stmt = $db->query("SELECT p.*, n.nup_number, n.customer FROM pengeluaran p JOIN nup n ON p.nup_id = n.id ORDER BY p.id DESC");
            echo json_encode(['ok' => true, 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
            break;

        case 'save_pengeluaran':
            $id = $input['id'] ?? null;
            $nup_id = (int)($input['nup_id'] ?? 0);
            $jenis = $input['jenis'] ?? 'po';
            $no_po = $input['no_po'] ?? null;
            $nama_vendor = $input['nama_vendor'] ?? '';
            $deskripsi = trim($input['deskripsi'] ?? '');
            $nilai = (float)($input['nilai'] ?? 0);
            $tgl_po = !empty($input['tgl_po']) ? $input['tgl_po'] : null;
            $tgl_bayar = !empty($input['tgl_bayar']) ? $input['tgl_bayar'] : null;
            $status_bayar = $input['status_bayar'] ?? 'belum';
            $remark = $input['remark'] ?? '';

            if (!$nup_id || empty($deskripsi) || $nilai <= 0) {
                http_response_code(400);
                echo json_encode(['error' => 'Pilih NUP, Deskripsi Pengeluaran, dan Nilai Nominal']);
                exit;
            }

            if ($id) {
                $stmt = $db->prepare("UPDATE pengeluaran SET nup_id=?, jenis=?, no_po=?, nama_vendor=?, deskripsi=?, nilai=?, tgl_po=?, tgl_bayar=?, status_bayar=?, remark=? WHERE id=?");
                $stmt->execute([$nup_id, $jenis, $no_po, $nama_vendor, $deskripsi, $nilai, $tgl_po, $tgl_bayar, $status_bayar, $remark, $id]);
            } else {
                $stmt = $db->prepare("INSERT INTO pengeluaran (nup_id, jenis, no_po, nama_vendor, deskripsi, nilai, tgl_po, tgl_bayar, status_bayar, remark) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nup_id, $jenis, $no_po, $nama_vendor, $deskripsi, $nilai, $tgl_po, $tgl_bayar, $status_bayar, $remark]);
                $id = $db->lastInsertId();
            }
            echo json_encode(['ok' => true, 'id' => $id, 'message' => 'Pengeluaran tersimpan']);
            break;

        case 'delete_pengeluaran':
            $id = (int)($input['id'] ?? $_GET['id'] ?? 0);
            if ($id) {
                $db->prepare("DELETE FROM pengeluaran WHERE id = ?")->execute([$id]);
            }
            echo json_encode(['ok' => true]);
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => 'Action tidak dikenali']);
            break;
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
