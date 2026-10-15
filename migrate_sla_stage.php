<?php
require_once __DIR__ . '/config.php';
try {
    $db = getDb();
    // Cek apakah kolom sudah ada
    $cols = $db->query("SHOW COLUMNS FROM projects LIKE 'sla_stage_id'")->fetchAll();
    if (empty($cols)) {
        $db->exec("ALTER TABLE projects ADD COLUMN sla_stage_id VARCHAR(50) DEFAULT NULL AFTER evidence_data");
        echo json_encode(['status' => 'success', 'message' => 'Kolom sla_stage_id berhasil ditambahkan ke tabel projects.']);
    } else {
        echo json_encode(['status' => 'already_exists', 'message' => 'Kolom sla_stage_id sudah ada.']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
