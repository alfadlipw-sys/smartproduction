<?php
// Script migrasi dan seeding tabel Industrial Services ke wsbandung_db
require_once __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $db = getDb();

    // 1. nup
    $db->exec("CREATE TABLE IF NOT EXISTS `nup` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `nup_number` VARCHAR(50) NOT NULL UNIQUE,
      `customer` VARCHAR(200) NOT NULL,
      `description` TEXT,
      `area` VARCHAR(100),
      `nilai_kontrak` DECIMAL(18,2) DEFAULT 0,
      `tgl_mulai` DATE,
      `tgl_selesai` DATE,
      `status` ENUM('aktif','selesai','hold','batal') DEFAULT 'aktif',
      `catatan` TEXT,
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 2. tagihan
    $db->exec("CREATE TABLE IF NOT EXISTS `tagihan` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `nup_id` INT UNSIGNED NOT NULL,
      `no_tagihan` VARCHAR(100) NOT NULL,
      `pekerjaan` VARCHAR(300) NOT NULL,
      `area` VARCHAR(100),
      `nilai` DECIMAL(18,2) DEFAULT 0,
      `tgl_tagihan` DATE,
      `status` ENUM('draft','dikirim','bal','create_bast','bast','lunas','batal') DEFAULT 'draft',
      `remark` TEXT,
      `created_by` VARCHAR(100),
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`nup_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 3. bal
    $db->exec("CREATE TABLE IF NOT EXISTS `bal` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `tagihan_id` INT UNSIGNED NOT NULL,
      `no_bal` VARCHAR(100) NOT NULL,
      `tgl_bal` DATE,
      `diterima_oleh` VARCHAR(200),
      `catatan` TEXT,
      `file_path` VARCHAR(500),
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`tagihan_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 4. bast
    $db->exec("CREATE TABLE IF NOT EXISTS `bast` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `tagihan_id` INT UNSIGNED NOT NULL,
      `bal_id` INT UNSIGNED,
      `no_bast` VARCHAR(100) NOT NULL,
      `tgl_bast` DATE,
      `nilai_bast` DECIMAL(18,2) DEFAULT 0,
      `penerima` VARCHAR(200),
      `jabatan` VARCHAR(200),
      `status` ENUM('draft','ditandatangani','final') DEFAULT 'draft',
      `catatan` TEXT,
      `file_path` VARCHAR(500),
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`tagihan_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 5. workshop_job
    $db->exec("CREATE TABLE IF NOT EXISTS `workshop_job` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `nup_id` INT UNSIGNED NOT NULL,
      `tagihan_id` INT UNSIGNED,
      `nama_pekerjaan` VARCHAR(300) NOT NULL,
      `area` VARCHAR(100),
      `tgl_plan_mulai` DATE,
      `tgl_plan_selesai` DATE,
      `tgl_aktual_mulai` DATE,
      `tgl_aktual_selesai` DATE,
      `progress_pct` TINYINT UNSIGNED DEFAULT 0,
      `status` ENUM('belum_mulai','on_progress','selesai','hold','batal') DEFAULT 'belum_mulai',
      `dp_dibayar` TINYINT(1) DEFAULT 0,
      `tgl_dp` DATE,
      `manpower_dibutuhkan` SMALLINT DEFAULT 0,
      `manpower_tersedia` SMALLINT DEFAULT 0,
      `is_late` TINYINT(1) DEFAULT 0,
      `alasan_keterlambatan` TEXT,
      `remark` TEXT,
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`nup_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 6. atpa
    $db->exec("CREATE TABLE IF NOT EXISTS `atpa` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `nup_id` INT UNSIGNED NOT NULL,
      `no_atpa` VARCHAR(100) NOT NULL,
      `tgl_atpa` DATE,
      `item` VARCHAR(300),
      `nilai` DECIMAL(18,2) DEFAULT 0,
      `status` ENUM('open','closed','rejected') DEFAULT 'open',
      `pic` VARCHAR(200),
      `catatan` TEXT,
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`nup_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // 7. pengeluaran
    $db->exec("CREATE TABLE IF NOT EXISTS `pengeluaran` (
      `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      `nup_id` INT UNSIGNED NOT NULL,
      `jenis` ENUM('po','unik','lainnya') DEFAULT 'po',
      `no_po` VARCHAR(100),
      `nama_vendor` VARCHAR(200),
      `deskripsi` VARCHAR(500) NOT NULL,
      `nilai` DECIMAL(18,2) DEFAULT 0,
      `tgl_po` DATE,
      `tgl_bayar` DATE,
      `status_bayar` ENUM('belum','sebagian','lunas') DEFAULT 'belum',
      `bukti_path` VARCHAR(500),
      `remark` TEXT,
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX (`nup_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

    // Seed contoh NUP jika masih kosong
    $chkNup = $db->query("SELECT COUNT(*) FROM nup")->fetchColumn();
    if ($chkNup == 0) {
        $db->exec("INSERT INTO `nup` (`nup_number`, `customer`, `description`, `area`, `nilai_kontrak`, `tgl_mulai`, `tgl_selesai`, `status`, `catatan`) VALUES
        ('NUP-2026-001', 'PT Pelita Air Service', 'Overhaul Komponen Auxiliary Unit & Hydraulic System WS Bandung', 'WS Bandung', 450000000.00, '2026-02-01', '2026-04-15', 'aktif', 'Prioritas operasional tinggi'),
        ('NUP-2026-002', 'PT Pertamina (Persero)', 'Machining & Dynamic Balancing Rotor Turbine Generator', 'Workshop 2', 320000000.00, '2026-02-15', '2026-03-30', 'aktif', 'Sesuai spesifikasi API 612'),
        ('NUP-2026-003', 'TNI Angkatan Udara', 'Repair & NDT Inspection Landing Gear Structure C-130', 'Hangar A', 680000000.00, '2026-01-10', '2026-05-20', 'aktif', 'Sertifikasi Militer');");

        $id1 = $db->query("SELECT id FROM nup WHERE nup_number = 'NUP-2026-001'")->fetchColumn();
        $id2 = $db->query("SELECT id FROM nup WHERE nup_number = 'NUP-2026-002'")->fetchColumn();

        if ($id1) {
            $db->exec("INSERT INTO `tagihan` (`nup_id`, `no_tagihan`, `pekerjaan`, `area`, `nilai`, `tgl_tagihan`, `status`, `remark`, `created_by`) VALUES
            ($id1, 'INV/PAS/2026/014', 'Termin 1 (DP 30%) Overhaul Hydraulic WS Bandung', 'WS Bandung', 135000000.00, '2026-02-05', 'lunas', 'DP terbayar penuh', 'Finance'),
            ($id1, 'INV/PAS/2026/029', 'Termin 2 (Progress 50%) Assembly & Testing', 'WS Bandung', 225000000.00, '2026-03-10', 'bal', 'Menunggu review dokumen BAL', 'Admin Prod');");

            $db->exec("INSERT INTO `workshop_job` (`nup_id`, `nama_pekerjaan`, `area`, `tgl_plan_mulai`, `tgl_plan_selesai`, `progress_pct`, `status`, `dp_dibayar`, `manpower_dibutuhkan`, `manpower_tersedia`, `is_late`, `alasan_keterlambatan`) VALUES
            ($id1, 'Disassembly & Cleaning Unit Hydraulic', 'WS Bandung', '2026-02-02', '2026-02-14', 100, 'selesai', 1, 4, 4, 0, NULL),
            ($id1, 'NDT Inspection & NUP Dimensional Check', 'Lab NDT', '2026-02-15', '2026-02-28', 100, 'selesai', 1, 3, 3, 0, NULL),
            ($id1, 'Hard Chrome Plating & Precision Grinding', 'Machining Bay', '2026-03-01', '2026-03-20', 65, 'on_progress', 1, 5, 4, 1, 'Tergantung kedatangan consumable seal kit impor');");

            $db->exec("INSERT INTO `atpa` (`nup_id`, `no_atpa`, `tgl_atpa`, `item`, `nilai`, `status`, `pic`, `catatan`) VALUES
            ($id1, 'ATPA-PAS-009', '2026-02-12', 'Special Tooling Fixture & Test Bench Hydraulic', 18500000.00, 'closed', 'Zanir / Tim WS', 'Peralatan terverifikasi aman');");

            $db->exec("INSERT INTO `pengeluaran` (`nup_id`, `jenis`, `no_po`, `nama_vendor`, `deskripsi`, `nilai`, `tgl_po`, `tgl_bayar`, `status_bayar`) VALUES
            ($id1, 'po', 'PO-IAS-26-041', 'PT Sealindo Mandiri', 'Seal Kit & O-Ring Aero Grade Viton', 34500000.00, '2026-02-08', '2026-02-10', 'lunas'),
            ($id1, 'unik', NULL, 'Workshop Bandung', 'Bahan Kimia Pembersih & Ultrasonic Cleaning Agent', 6200000.00, '2026-02-12', '2026-02-12', 'lunas');");
        }
    }

    echo json_encode(['status' => 'success', 'message' => 'Tabel industrial services berhasil dipasang dan diverifikasi.']);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
