-- ============================================================
--  MIGRATION: Tambah kolom sla_stage_id ke tabel projects
--  Database : wsbandung_db
--  Jalankan di: phpMyAdmin → pilih database wsbandung_db → SQL
-- ============================================================

USE `wsbandung_db`;

-- Tambah kolom sla_stage_id (pilihan tahapan SLA per proyek)
-- Aman dijalankan berkali-kali karena pakai IF NOT EXISTS (MariaDB 10.0+)
ALTER TABLE `projects`
  ADD COLUMN IF NOT EXISTS `sla_stage_id` VARCHAR(50) DEFAULT NULL
  AFTER `evidence_data`;

-- Verifikasi: lihat struktur tabel setelah migrasi
SHOW COLUMNS FROM `projects` LIKE 'sla_stage_id';
