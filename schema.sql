-- Database untuk dashboard wsbandung (menggantikan localStorage-only + stub Firebase)
CREATE DATABASE IF NOT EXISTS wsbandung_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wsbandung_db;


-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 22 Jul 2026 pada 14.17
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wsbandung_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `dashboard_data`
--

CREATE TABLE `dashboard_data` (
  `id` int(11) NOT NULL,
  `data_key` varchar(191) NOT NULL,
  `data_value` longtext NOT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `period` varchar(7) NOT NULL,
  `name` varchar(191) NOT NULL,
  `role` varchar(100) NOT NULL DEFAULT '',
  `join_date` date DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`tags`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `employees`
--

INSERT INTO `employees` (`id`, `period`, `name`, `role`, `join_date`, `target_date`, `tags`, `updated_at`) VALUES
(24, '2026-06', 'Bayu', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(25, '2026-06', 'Haris', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(26, '2026-06', 'Irfan', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(27, '2026-06', 'Sendy', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(28, '2026-06', 'Dika', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(29, '2026-06', 'Adit', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(30, '2026-06', 'Diki', 'Welding', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(31, '2026-06', 'Cepi', 'Welding', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(32, '2026-06', 'Yudi Siswantoro', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(33, '2026-06', 'Yudi Setiawan', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(34, '2026-06', 'Agus', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(35, '2026-06', 'Egi', 'Helper', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(36, '2026-06', 'Ghisa', 'Helper', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(37, '2026-06', 'Irwan', 'Engineer', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(38, '2026-06', 'Wibbie', 'Drafter', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(39, '2026-06', 'Ikhsan', 'Balancing', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(40, '2026-06', 'April', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(41, '2026-06', 'Wildan', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(42, '2026-06', 'Wini', 'HRD', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(43, '2026-06', 'Dea', 'HRD', NULL, NULL, '[]', '2026-07-09 12:52:34'),
(44, '2026-05', 'Bayu', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(45, '2026-05', 'Haris', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(46, '2026-05', 'Irfan', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(47, '2026-05', 'Sendy', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(48, '2026-05', 'Dika', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(49, '2026-05', 'Adit', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(50, '2026-05', 'Diki', 'Welding', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(51, '2026-05', 'Cepi', 'Welding', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(52, '2026-05', 'Yudi Siswantoro', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(53, '2026-05', 'Yudi Setiawan', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(54, '2026-05', 'Agus', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(55, '2026-05', 'Egi', 'Helper', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(56, '2026-05', 'Ghisa', 'Helper', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(57, '2026-05', 'Irwan', 'Engineer', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(58, '2026-05', 'Wibbie', 'Drafter', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(59, '2026-05', 'Ikhsan', 'Balancing', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(60, '2026-05', 'April', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(61, '2026-05', 'Wildan', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(62, '2026-05', 'Wini', 'HRD', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(63, '2026-05', 'Dea', 'HRD', NULL, NULL, '[]', '2026-07-09 12:52:53'),
(64, '2026-08', 'Bayu', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(65, '2026-08', 'Haris', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(66, '2026-08', 'Irfan', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(67, '2026-08', 'Sendy', 'Bubut', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(68, '2026-08', 'Dika', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(69, '2026-08', 'Adit', 'CNC / Milling', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(70, '2026-08', 'Diki', 'Welding', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(71, '2026-08', 'Cepi', 'Welding', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(72, '2026-08', 'Yudi Siswantoro', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(73, '2026-08', 'Yudi Setiawan', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(74, '2026-08', 'Agus', 'Mechanic', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(75, '2026-08', 'Egi', 'Helper', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(76, '2026-08', 'Ghisa', 'Helper', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(77, '2026-08', 'Irwan', 'Engineer', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(78, '2026-08', 'Wibbie', 'Drafter', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(79, '2026-08', 'Ikhsan', 'Balancing', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(80, '2026-08', 'April', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(81, '2026-08', 'Wildan', 'SCM / Tools', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(82, '2026-08', 'Wini', 'HRD', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(83, '2026-08', 'Dea', 'HRD', NULL, NULL, '[]', '2026-07-09 12:53:00'),
(184, '2026-07', 'Bayu', 'Bubut', '2026-07-08', '2026-07-17', '[{\"label\":\"100-P-6\",\"terima\":1,\"actualTarget\":1,\"target\":3}]', '2026-07-12 23:57:26'),
(185, '2026-07', 'Haris', 'Bubut', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(186, '2026-07', 'Irfan', 'Bubut', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(187, '2026-07', 'Sendy', 'Bubut', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(188, '2026-07', 'Dika', 'CNC / Milling', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(189, '2026-07', 'Adit', 'CNC / Milling', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(190, '2026-07', 'Diki', 'Welding', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(191, '2026-07', 'Cepi', 'Welding', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(192, '2026-07', 'Yudi Siswantoro', 'Mechanic', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(193, '2026-07', 'Yudi Setiawan', 'Mechanic', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(194, '2026-07', 'Agus', 'Mechanic', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(195, '2026-07', 'Egi', 'Helper', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(196, '2026-07', 'Ghisa', 'Helper', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(197, '2026-07', 'Irwan', 'Engineer', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(198, '2026-07', 'Wibbie', 'Drafter', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(199, '2026-07', 'Ikhsan', 'Balancing', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(200, '2026-07', 'April', 'SCM / Tools', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(201, '2026-07', 'Wildan', 'SCM / Tools', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(202, '2026-07', 'Wini', 'HRD', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(203, '2026-07', 'Dea', 'HRD', NULL, NULL, '[]', '2026-07-12 23:57:26'),
(204, '2025-02', 'Bayu', 'Bubut', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(205, '2025-02', 'Haris', 'Bubut', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(206, '2025-02', 'Irfan', 'Bubut', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(207, '2025-02', 'Sendy', 'Bubut', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(208, '2025-02', 'Dika', 'CNC / Milling', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(209, '2025-02', 'Adit', 'CNC / Milling', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(210, '2025-02', 'Diki', 'Welding', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(211, '2025-02', 'Cepi', 'Welding', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(212, '2025-02', 'Yudi Siswantoro', 'Mechanic', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(213, '2025-02', 'Yudi Setiawan', 'Mechanic', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(214, '2025-02', 'Agus', 'Mechanic', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(215, '2025-02', 'Egi', 'Helper', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(216, '2025-02', 'Ghisa', 'Helper', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(217, '2025-02', 'Irwan', 'Engineer', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(218, '2025-02', 'Wibbie', 'Drafter', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(219, '2025-02', 'Ikhsan', 'Balancing', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(220, '2025-02', 'April', 'SCM / Tools', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(221, '2025-02', 'Wildan', 'SCM / Tools', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(222, '2025-02', 'Wini', 'HRD', NULL, NULL, '[]', '2026-07-14 03:07:17'),
(223, '2025-02', 'Dea', 'HRD', NULL, NULL, '[]', '2026-07-14 03:07:17');

-- --------------------------------------------------------

--
-- Struktur dari tabel `projects`
--

CREATE TABLE `projects` (
  `id` bigint(20) NOT NULL,
  `period` varchar(7) NOT NULL,
  `name` varchar(191) NOT NULL,
  `client` varchar(191) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `dept` varchar(100) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `evidence_file` varchar(255) DEFAULT NULL,
  `evidence_data` longtext DEFAULT NULL,
  `sla_stage_id` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Dumping data untuk tabel `projects`
--

INSERT INTO `projects` (`id`, `period`, `name`, `client`, `start_date`, `end_date`, `status`, `dept`, `remarks`, `evidence_file`, `evidence_data`, `updated_at`) VALUES
(1783601645885, '2026-07', '100-P-6', '', '2026-07-06', '2026-09-27', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783615850018, '2026-07', '510-P-1A', '', '2026-07-06', '2026-10-22', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783742898763, '2026-07', '580-P-302A', '', '2025-01-15', '2025-04-05', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783744941451, '2026-07', '925-P-6A', '', '2026-06-29', '2026-09-17', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783749559298, '2026-07', '52B201K1', '', '2025-12-25', '2026-03-15', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783753005905, '2026-07', '580 -P -301A', '', '2025-10-09', '2025-12-28', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783753077425, '2026-07', '580 -P-301D', '', '2026-06-30', '2026-09-18', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783859993374, '2026-07', 'Elmot 42', '', '2026-07-13', '2026-10-01', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56'),
(1783998460795, '2026-07', '502-K', '', '2026-07-09', '2026-09-24', 'Ongoing', '', '', '', '', '2026-07-22 03:41:56');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sla_projects`
--

CREATE TABLE `sla_projects` (
  `id` bigint(20) NOT NULL,
  `period` varchar(7) NOT NULL,
  `name` varchar(191) NOT NULL,
  `start_date` date DEFAULT NULL,
  `actual_end_date` date DEFAULT NULL,
  `work_type` varchar(50) DEFAULT NULL,
  `stages` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`stages`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sla_projects`
--

INSERT INTO `sla_projects` (`id`, `period`, `name`, `start_date`, `actual_end_date`, `work_type`, `stages`, `updated_at`) VALUES
(1783601645885, '2026-07', '100-P-6', '2026-07-06', NULL, 'inspection', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":6,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\"}]', '2026-07-22 12:10:59'),
(1783615850018, '2026-07', '510-P-1A', '2026-07-06', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":1,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"startDate\":\"2026-07-06T00:00:00.000Z\",\"endDate\":\"2026-07-07T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Terlambat\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"startDate\":\"2026-07-07T00:00:00.000Z\",\"endDate\":\"2026-07-12T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Terlambat\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":9,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"startDate\":\"2026-07-12T00:00:00.000Z\",\"endDate\":\"2026-07-21T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Terlambat\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":11,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"startDate\":\"2026-07-21T00:00:00.000Z\",\"endDate\":\"2026-08-01T00:00:00.000Z\",\"status\":\"ongoing\",\"subtasks\":[{\"emps\":[\"Egi\",\"Irwan\"],\"desc\":\"Inspeksi barang pompa\",\"date\":\"2026-07-22\",\"targetDate\":\"2026-07-23\",\"bobot\":40,\"isDone\":true,\"id\":1784692454388}],\"actualPct\":40,\"statusState\":\"Follow Up\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":45,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"startDate\":\"2026-08-01T00:00:00.000Z\",\"endDate\":\"2026-09-15T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"startDate\":\"2026-09-15T00:00:00.000Z\",\"endDate\":\"2026-09-29T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"startDate\":\"2026-09-29T00:00:00.000Z\",\"endDate\":\"2026-10-09T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"startDate\":\"2026-10-09T00:00:00.000Z\",\"endDate\":\"2026-10-12T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"startDate\":\"2026-10-12T00:00:00.000Z\",\"endDate\":\"2026-10-15T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"startDate\":\"2026-10-15T00:00:00.000Z\",\"endDate\":\"2026-10-20T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"startDate\":\"2026-10-20T00:00:00.000Z\",\"endDate\":\"2026-10-22T00:00:00.000Z\",\"status\":\"pending\"}]', '2026-07-22 12:10:59'),
(1783742898763, '2026-07', '580-P-302A', '2025-01-15', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"actualPct\":0,\"startDate\":\"2026-06-26T00:00:00.000Z\",\"endDate\":\"2026-06-29T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"actualPct\":0,\"startDate\":\"2026-06-29T00:00:00.000Z\",\"endDate\":\"2026-07-04T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"actualPct\":0,\"startDate\":\"2026-07-04T00:00:00.000Z\",\"endDate\":\"2026-07-06T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"actualPct\":0,\"startDate\":\"2026-07-06T00:00:00.000Z\",\"endDate\":\"2026-07-09T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"actualPct\":0,\"startDate\":\"2026-07-09T00:00:00.000Z\",\"endDate\":\"2026-08-08T00:00:00.000Z\",\"status\":\"ongoing\",\"statusState\":\"Selesai\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"actualPct\":0,\"startDate\":\"2026-08-08T00:00:00.000Z\",\"endDate\":\"2026-08-22T00:00:00.000Z\",\"status\":\"pending\",\"statusState\":\"Selesai\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"actualPct\":0,\"startDate\":\"2026-08-22T00:00:00.000Z\",\"endDate\":\"2026-09-01T00:00:00.000Z\",\"status\":\"pending\",\"subtasks\":[{\"emp\":\"-\",\"desc\":\"Payment Issue\",\"date\":\"2026-06-26\",\"targetDate\":\"2026-07-10\",\"isDone\":false,\"id\":1783744221987},{\"emp\":\"-\",\"desc\":\"Menunggu pengiriman unit rotor pompa dari Pt. Fuji ke workshop cileunyi\",\"date\":\"2026-06-26\",\"targetDate\":\"2026-07-10\",\"isDone\":false,\"id\":1783744727618}],\"statusState\":\"Hold\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"actualPct\":0,\"startDate\":\"2026-09-01T00:00:00.000Z\",\"endDate\":\"2026-09-04T00:00:00.000Z\",\"status\":\"pending\",\"statusState\":\"Selesai\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"actualPct\":0,\"startDate\":\"2026-09-04T00:00:00.000Z\",\"endDate\":\"2026-09-07T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"actualPct\":0,\"startDate\":\"2026-09-07T00:00:00.000Z\",\"endDate\":\"2026-09-12T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"actualPct\":0,\"startDate\":\"2026-09-12T00:00:00.000Z\",\"endDate\":\"2026-09-14T00:00:00.000Z\",\"status\":\"pending\"}]', '2026-07-22 12:10:59'),
(1783744941451, '2026-07', '925-P-6A', '2026-06-29', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"actualPct\":0,\"startDate\":\"2026-06-29T00:00:00.000Z\",\"endDate\":\"2026-07-02T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"actualPct\":0,\"startDate\":\"2026-07-02T00:00:00.000Z\",\"endDate\":\"2026-07-07T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"actualPct\":0,\"startDate\":\"2026-07-07T00:00:00.000Z\",\"endDate\":\"2026-07-09T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"actualPct\":0,\"startDate\":\"2026-07-09T00:00:00.000Z\",\"endDate\":\"2026-07-12T00:00:00.000Z\",\"status\":\"ongoing\",\"statusState\":\"Selesai\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"actualPct\":0,\"startDate\":\"2026-07-12T00:00:00.000Z\",\"endDate\":\"2026-08-11T00:00:00.000Z\",\"status\":\"pending\",\"statusState\":\"Selesai\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"actualPct\":0,\"startDate\":\"2026-08-11T00:00:00.000Z\",\"endDate\":\"2026-08-25T00:00:00.000Z\",\"status\":\"pending\",\"statusState\":\"Selesai\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"actualPct\":100,\"startDate\":\"2026-08-25T00:00:00.000Z\",\"endDate\":\"2026-09-04T00:00:00.000Z\",\"status\":\"pending\",\"subtasks\":[{\"emp\":\"Haris\",\"desc\":\"Pembubutan Bearing spider dan Coulumn\",\"date\":\"2026-06-29\",\"targetDate\":\"2026-07-03\",\"isDone\":true,\"id\":1783745131867},{\"emp\":\"Diki, Cepi\",\"desc\":\"Polishing column agar bisa pas dengan bearing spider\",\"date\":\"2026-07-02\",\"targetDate\":\"2026-07-03\",\"isDone\":true,\"id\":1783745321002},{\"emp\":\"Diki, Cepi\",\"desc\":\"Telah selesai untuk polishing column dan sudah di assembly\",\"date\":\"2026-07-03\",\"targetDate\":\"2026-07-03\",\"isDone\":true,\"id\":1783745372386},{\"emp\":\"Yudi Setiawan, Agus\",\"desc\":\"*Dilakukan pengecekan ulang untuk coulumn untuk diurutkan sesuai urutannya\",\"date\":\"2026-07-06\",\"targetDate\":\"2026-07-06\",\"isDone\":true,\"id\":1783745431690},{\"emp\":\"Wibbie\",\"desc\":\"Final Report sudah di submit\",\"date\":\"2026-07-07\",\"targetDate\":\"2026-07-07\",\"isDone\":true,\"id\":1783745529362}],\"statusState\":\"Selesai\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"actualPct\":0,\"startDate\":\"2026-09-04T00:00:00.000Z\",\"endDate\":\"2026-09-07T00:00:00.000Z\",\"status\":\"pending\",\"statusState\":\"Selesai\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"actualPct\":0,\"startDate\":\"2026-09-07T00:00:00.000Z\",\"endDate\":\"2026-09-10T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"actualPct\":0,\"startDate\":\"2026-09-10T00:00:00.000Z\",\"endDate\":\"2026-09-15T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"actualPct\":0,\"startDate\":\"2026-09-15T00:00:00.000Z\",\"endDate\":\"2026-09-17T00:00:00.000Z\",\"status\":\"pending\"}]', '2026-07-22 12:10:59'),
(1783749559298, '2026-07', '52B201K1', '2025-12-25', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"actualPct\":0,\"startDate\":\"2025-12-25T00:00:00.000Z\",\"endDate\":\"2025-12-28T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"actualPct\":0,\"startDate\":\"2025-12-28T00:00:00.000Z\",\"endDate\":\"2026-01-02T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"actualPct\":0,\"startDate\":\"2026-01-02T00:00:00.000Z\",\"endDate\":\"2026-01-04T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"actualPct\":0,\"startDate\":\"2026-01-04T00:00:00.000Z\",\"endDate\":\"2026-01-07T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"actualPct\":0,\"startDate\":\"2026-01-07T00:00:00.000Z\",\"endDate\":\"2026-02-06T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"actualPct\":0,\"startDate\":\"2026-02-06T00:00:00.000Z\",\"endDate\":\"2026-02-20T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\",\"subtasks\":[]},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"actualPct\":100,\"startDate\":\"2026-02-20T00:00:00.000Z\",\"endDate\":\"2026-03-02T00:00:00.000Z\",\"status\":\"done\",\"subtasks\":[{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"Report on Progress untuk kemarin ada temuan hasil run out masih di luar batas toleransi\",\"date\":\"2026-07-03\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873466246},{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"Dilakukan run out lagi untuk memastikan masih di dalam batas toleransi atau tidak\",\"date\":\"2026-07-07\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873513431},{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"Dilakukan Coating\",\"date\":\"2026-07-08\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873555183},{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"Dilakukan coating dan akan dilakukan run out lagi karena dari hasil run out pada tanggal 07\\/07\\/2026 masih kurang bagus\",\"date\":\"2026-07-09\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873590983},{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"Masih dilakukan coating dan akan dilakukan run out lagi karena dari hasil run out yang sebelumnya masih kurang bagus\",\"date\":\"2026-07-10\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873624430},{\"emp\":\"Irwan, Yudi Setiawan\",\"desc\":\"*Untuk repair per jam 3 hari sabtu 11\\/07\\/2026 sudah selesai dan untuk reportnya sedang disusun akan disubmit per hari sabtu 11\\/07\\/2026\",\"date\":\"2026-07-11\",\"targetDate\":\"2026-07-13\",\"isDone\":true,\"id\":1783873687244}],\"statusState\":\"Selesai\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"actualPct\":0,\"startDate\":\"2026-03-02T00:00:00.000Z\",\"endDate\":\"2026-03-05T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"actualPct\":0,\"startDate\":\"2026-03-05T00:00:00.000Z\",\"endDate\":\"2026-03-08T00:00:00.000Z\",\"status\":\"done\",\"subtasks\":[{\"emp\":\"Irwan\",\"desc\":\"Dilakukan JFI pada tanggal 17 Juli 2026 info dari pertamina\",\"date\":\"2026-07-17\",\"targetDate\":\"2026-07-20\",\"isDone\":false,\"id\":1783859226570}]},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"actualPct\":0,\"startDate\":\"2026-03-08T00:00:00.000Z\",\"endDate\":\"2026-03-13T00:00:00.000Z\",\"status\":\"done\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"actualPct\":0,\"startDate\":\"2026-03-13T00:00:00.000Z\",\"endDate\":\"2026-03-15T00:00:00.000Z\",\"status\":\"done\"}]', '2026-07-22 12:10:59'),
(1783753005905, '2026-07', '580 -P -301A', '2025-10-09', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"actualPct\":100,\"startDate\":\"2025-10-09T00:00:00.000Z\",\"endDate\":\"2025-10-12T00:00:00.000Z\",\"status\":\"done\",\"subtasks\":[],\"statusState\":\"Selesai\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"actualPct\":100,\"startDate\":\"2025-10-12T00:00:00.000Z\",\"endDate\":\"2025-10-17T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"actualPct\":100,\"startDate\":\"2025-10-17T00:00:00.000Z\",\"endDate\":\"2025-10-19T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"actualPct\":100,\"startDate\":\"2025-10-19T00:00:00.000Z\",\"endDate\":\"2025-10-22T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"actualPct\":100,\"startDate\":\"2025-10-22T00:00:00.000Z\",\"endDate\":\"2025-11-21T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"actualPct\":0,\"startDate\":\"2025-11-21T00:00:00.000Z\",\"endDate\":\"2025-12-05T00:00:00.000Z\",\"status\":\"done\",\"subtasks\":[{\"emp\":\"Wibbie, Irwan\",\"desc\":\"Sedang menunggu part dari vendor PT. SKM berupa Discharge Head, Report final on progress\",\"date\":\"2026-07-02\",\"targetDate\":\"2026-07-13\",\"isDone\":false,\"id\":1783873862751},{\"emp\":\"Wibbie, Irwan\",\"desc\":\"Inspeksi ke vendor PT. SKM siap pada tanggal 11 Juli 2026\",\"date\":\"2026-07-06\",\"targetDate\":\"2026-07-13\",\"isDone\":false,\"id\":1783874004686}]},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"actualPct\":0,\"startDate\":\"2025-12-05T00:00:00.000Z\",\"endDate\":\"2025-12-15T00:00:00.000Z\",\"status\":\"done\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"actualPct\":0,\"startDate\":\"2025-12-15T00:00:00.000Z\",\"endDate\":\"2025-12-18T00:00:00.000Z\",\"status\":\"done\",\"statusState\":\"Selesai\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"actualPct\":0,\"startDate\":\"2025-12-18T00:00:00.000Z\",\"endDate\":\"2025-12-21T00:00:00.000Z\",\"status\":\"done\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"actualPct\":0,\"startDate\":\"2025-12-21T00:00:00.000Z\",\"endDate\":\"2025-12-26T00:00:00.000Z\",\"status\":\"done\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"actualPct\":0,\"startDate\":\"2025-12-26T00:00:00.000Z\",\"endDate\":\"2025-12-28T00:00:00.000Z\",\"status\":\"done\"}]', '2026-07-22 12:10:59'),
(1783753077425, '2026-07', '580 -P-301D', '2026-06-30', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\"}]', '2026-07-22 12:10:59'),
(1783859993374, '2026-07', 'Elmot 42', '2026-07-13', NULL, 'overhaul', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\",\"actualPct\":0,\"startDate\":\"2026-07-13T00:00:00.000Z\",\"endDate\":\"2026-07-16T00:00:00.000Z\",\"status\":\"pending\",\"subtasks\":[{\"emp\":\"-\",\"desc\":\"Masih menunggu SPK\",\"date\":\"2026-07-13\",\"targetDate\":\"2026-07-13\",\"isDone\":false,\"id\":1783860017395}]},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\",\"actualPct\":0,\"startDate\":\"2026-07-16T00:00:00.000Z\",\"endDate\":\"2026-07-21T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\",\"actualPct\":0,\"startDate\":\"2026-07-21T00:00:00.000Z\",\"endDate\":\"2026-07-23T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\",\"actualPct\":0,\"startDate\":\"2026-07-23T00:00:00.000Z\",\"endDate\":\"2026-07-26T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\",\"actualPct\":0,\"startDate\":\"2026-07-26T00:00:00.000Z\",\"endDate\":\"2026-08-25T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\",\"actualPct\":0,\"startDate\":\"2026-08-25T00:00:00.000Z\",\"endDate\":\"2026-09-08T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\",\"actualPct\":0,\"startDate\":\"2026-09-08T00:00:00.000Z\",\"endDate\":\"2026-09-18T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\",\"actualPct\":0,\"startDate\":\"2026-09-18T00:00:00.000Z\",\"endDate\":\"2026-09-21T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\",\"actualPct\":0,\"startDate\":\"2026-09-21T00:00:00.000Z\",\"endDate\":\"2026-09-24T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\",\"actualPct\":0,\"startDate\":\"2026-09-24T00:00:00.000Z\",\"endDate\":\"2026-09-29T00:00:00.000Z\",\"status\":\"pending\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\",\"actualPct\":0,\"startDate\":\"2026-09-29T00:00:00.000Z\",\"endDate\":\"2026-10-01T00:00:00.000Z\",\"status\":\"pending\"}]', '2026-07-22 12:10:59'),
(1783998460795, '2026-07', '502-K', '2026-07-09', NULL, 'maintenance', '[{\"id\":1,\"name\":\"Mobilisasi\",\"dur\":0,\"pic\":[\"WS\"],\"desc\":\"Penerimaan & mobilisasi unit ke workshop\"},{\"id\":2,\"name\":\"Pembongkaran Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Disassembly lengkap seluruh komponen\"},{\"id\":3,\"name\":\"Incoming Inspection\",\"dur\":2,\"pic\":[\"WS\"],\"desc\":\"Inspeksi & dokumentasi kondisi komponen\"},{\"id\":4,\"name\":\"Joint Incoming Inspection (JII)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JII bersama customer\\/PTM Engineering\"},{\"id\":5,\"name\":\"Pengadaan Material & Approval Drawing\",\"dur\":30,\"pic\":[\"SCM\",\"Finance\",\"Drafter\"],\"desc\":\"Proses pengadaan semua material, Jasa & consumable, Drafter\"},{\"id\":6,\"name\":\"Fabrikasi\",\"dur\":14,\"pic\":[\"WS\",\"SCM\"],\"desc\":\"Fabrikasi komponen baru (internal\\/vendor)\"},{\"id\":7,\"name\":\"Repair Part\",\"dur\":10,\"pic\":[\"WS\"],\"desc\":\"Perbaikan\\/reconditioning komponen existing\"},{\"id\":8,\"name\":\"Balancing\",\"dur\":3,\"pic\":[\"WS\"],\"desc\":\"Dynamic balancing rotor\\/impeller\"},{\"id\":9,\"name\":\"Joint Final Inspection (JFI)\",\"dur\":3,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"JFI bersama customer\\/PTM sebelum assembly\"},{\"id\":10,\"name\":\"Pemasangan Unit\",\"dur\":5,\"pic\":[\"WS\"],\"desc\":\"Assembly, reassembly & final test\"},{\"id\":11,\"name\":\"Demobilisasi\",\"dur\":2,\"pic\":[\"WS\",\"AREA\"],\"desc\":\"Pengiriman unit ke customer\\/site\"}]', '2026-07-22 12:10:59');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_period_name` (`period`,`name`);

--
-- Indeks untuk tabel `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_period` (`period`);

--
-- Indeks untuk tabel `sla_projects`
--
ALTER TABLE `sla_projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_period` (`period`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=224;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

