# Smart Production – PT Indopelita Aircraft Services (IAS)

Platform terintegrasi untuk monitoring operasional bengkel/workshop (*WS Bandung*), kurva S SLA (*S-Curve SLA*), performa karyawan, serta manajemen alur industri berbasis **NUP (Nomor Urut Pekerjaan)** mulai dari kontrak, pekerjaan lapangan, penagihan (Invoice, BAL, BAST), pengeluaran proyek (PO/Unik), hingga tracking *late schedule*.

---

## 📑 Daftar Isi
1. [Gambaran Umum Sistem](#-gambaran-umum-sistem)
2. [Teknologi yang Digunakan (Tech Stack)](#-teknologi-yang-digunakan-tech-stack)
3. [Struktur Folder & Berkas](#-struktur-folder--berkas)
4. [Arsitektur & Alur Kerja (Workflows)](#-arsitektur--alur-kerja-workflows)
   - [4.1 Peta Navigasi Halaman Portal](#41-peta-navigasi-halaman-portal)
   - [4.2 Alur Data Dashboard WS Bandung (dashboard.html)](#42-alur-data-dashboard-ws-bandung-dashboardhtml)
   - [4.3 Alur Siklus Industri NUP (industrial.html)](#43-alur-siklus-industri-nup-industrialhtml)
5. [Struktur Database (MySQL / MariaDB)](#-struktur-database-mysql--mariadb)
6. [Role & Kontrol Hak Akses](#-role--kontrol-hak-akses)
7. [Panduan Instalasi & Menjalankan di Lokal](#-panduan-instalasi--menjalankan-di-lokal)
8. [Spesifikasi REST API](#-spesifikasi-rest-api)
9. [Catatan Pemeliharaan & Troubleshooting](#-catatan-pemeliharaan--troubleshooting)

---

## 🌟 Gambaran Umum Sistem

Sistem ini terdiri dari dua modul besar yang dihubungkan melalui satu halaman portal gerbang (*index.html*):

1. **Dashboard WS Bandung (`dashboard.html`)**
   - **Dashboard Karyawan**: Monitoring tag tugas/pekerjaan per teknisi, timeline tanggal masuk vs tanggal target, input jam kerja kumulatif real-time vs target, serta rekap tahunan/bulanan.
   - **S-Curve SLA**: Perhitungan otomatis kurva S untuk tahapan proyek workshop (*Overhaul*, *Inspection*, *Repair*, *Maintenance*), pembagian subtask ke personel, dan status keterlambatan SLA.
   - **Daftar Proyek**: Registri proyek berjalan dan selesai dengan filter tahunan atau kumulatif, serta keterkaitan (*mapping*) ke tahapan SLA.
   - **Summary Bulanan**: Matriks performa 12 bulan karyawan (Jan–Des) per divisi beserta agregasi SLA subtask yang ditangani.
   - **Issue & Alarm**: Rekap kendala operasional subtask dan peringatan dini (*early warning*) batas waktu SLA.

2. **Industrial Services (`industrial.html`)**
   - **Manajemen NUP**: Pencatatan nomor kontrak/pekerjaan industri, nilai kontrak, status pekerjaan (*aktif/selesai/hold/batal*), dan margin proyek.
   - **Tagihan & Invoice**: Siklus penagihan bertahap (*Termin/DP*) dari draft, pengiriman invoice, penerbitan BAL (*Berita Acara Lapangan*), hingga BAST (*Berita Acara Serah Terima*) dan pelunasan.
   - **Workshop Jobs**: Rincian pekerjaan fisik bengkel, alokasi manpower, persentase progres, dan pelacakan *Late Schedule*.
   - **ATPA**: Manajemen Alat Bantu / Tooling / Pengadaan Alat bantu kerja.
   - **Pengeluaran**: Monitoring pengeluaran berbasis PO Vendor dan pengeluaran unik/internal bengkel.

---

## 💻 Teknologi yang Digunakan (Tech Stack)

### Frontend
- **HTML5 & CSS3 Vanilla**: Menggunakan CSS Custom Properties, layout Flexbox & Grid, Glassmorphism UI, dan desain responsif bertema Dark Navy/Aerospace.
- **JavaScript (ES6+)**: SPA logic, asynchronous data fetch, DOM manipulation dinamis.
- **Library Pihak Ketiga (via CDN)**:
  - [Chart.js 4.4.0](https://www.chartjs.org/) + `chartjs-plugin-annotation` (Visualisasi kurva S dan status tren).
  - [Plotly.js 2.24.1](https://plotly.com/javascript/) (Grafik batang Tag Number dan garis target kumulatif jam kerja karyawan).
  - [SheetJS / xlsx 0.20.0](https://sheetjs.com/) (Import data karyawan dari file Excel spreadsheet).
  - [html2pdf.js 0.10.1](https://ekoopmans.github.io/html2pdf.js/) (Ekspor laporan dashboard ke dokumen PDF).

### Backend
- **PHP 8.x**: Native procedural & PDO (*PHP Data Objects*) tanpa framework berat agar ringan dan mudah di-host pada lingkungan XAMPP lokal.
- **Autentikasi API**: Token bersama (*Shared Secret API Key*) dikirim melalui header `X-Api-Key`.

### Database
- **MySQL / MariaDB (InnoDB)**: Penyimpanan relasional dengan dukungan kolom format JSON untuk struktur dinamis (seperti tahapan SLA dan array tags karyawan).

---

## 📂 Struktur Folder & Berkas

```plaintext
smartproduction/
│
├── index.html                   # Halaman Portal Utama (Landing page pengarah modul)
├── dashboard.html               # Modul Utama: Dashboard Workshop & S-Curve SLA WS Bandung
├── industrial.html              # Modul Utama: Smart Production Industrial Services (NUP, Invoice, BAST, PO)
│
├── config.php                   # Konfigurasi koneksi database PDO & Shared API Secret
├── api.php                      # Endpoint REST API untuk modul dashboard.html (employees, sla_projects, projects)
├── industrial_api.php           # Endpoint REST API untuk modul industrial.html (nup, tagihan, bal, bast, job, atpa, po)
│
├── schema.sql                   # Skema DDL & seed data awal database wsbandung_db
├── setup_industrial_tables.php  # Skrip migrasi & auto-seeding tabel-tabel Industrial Services
├── migration_add_sla_stage.sql  # Skrip migrasi penambahan kolom sla_stage_id pada tabel projects
├── migrate_sla_stage.php        # Skrip PHP eksekutor migrasi kolom sla_stage_id
│
├── bugs.md                      # Log audit temuan bug, celah keamanan, dan riwayat perbaikan
├── README.md                    # Dokumentasi lengkap struktur dan flow sistem
│
├── bg.png                       # Asset latar belakang visual antarmuka
└── logo.png                     # Asset logo resmi PT Indopelita Aircraft Services
```

---

## 🔄 Arsitektur & Alur Kerja (Workflows)

### 4.1 Peta Navigasi Halaman Portal

```
                       ┌─────────────────────────┐
                       │       index.html        │
                       │   (Portal Beranda IAS)  │
                       └────────────┬────────────┘
                                    │
           ┌────────────────────────┴────────────────────────┐
           ▼                                                 ▼
┌───────────────────────┐                         ┌───────────────────────┐
│     dashboard.html    │                         │    industrial.html    │
│  (Workshop & S-Curve) │                         │ (Industrial Services) │
├───────────────────────┤                         ├───────────────────────┤
│ • Tab Karyawan        │                         │ • Executive Summary   │
│ • Tab S-Curve SLA     │                         │ • NUP Management      │
│ • Tab Daftar Proyek   │                         │ • Tagihan, BAL & BAST │
│ • Tab Summary Bulanan │                         │ • Workshop Jobs & Late│
│ • Tab Issue & Alarm   │                         │ • ATPA & Pengeluaran  │
└───────────────────────┘                         └───────────────────────┘
```

---

### 4.2 Alur Data Dashboard WS Bandung (`dashboard.html`)

Sistem mengadopsi mekanisme **Local-First Caching with Database Hydration**:

```
[ User Buka Browser ]
         │
         ▼
[ Inisialisasi Periode ] ─── Default: Tahun Berjalan (misal: "2026")
         │
         ▼
[ Hydration dari Backend (api.php) ]
  ├── GET api.php?entity=employees&year=2026
  ├── GET api.php?entity=employee_summary&year=2026
  ├── GET api.php?entity=sla_projects&all=1
  └── GET api.php?entity=projects&all=1
         │
         ▼
[ Penyimpanan Cache Lokal ] ─── Simpan ke LocalStorage per-periode (ias_employee_data_YYYY-MM, dsb)
         │
         ▼
[ Render Tampilan (UI) ]
  ├── Gabungkan tag Jan–Des karyawan untuk tahun terpilih
  ├── Render kurva S berdasarkan bobot durasi tahapan SLA
  ├── Evaluasi notifikasi keterlambatan untuk tab Issue & Alarm
  └── Hitung matriks utilisasi karyawan di Tab Summary Bulanan
         │
         ▼
[ Input / Perubahan Data oleh User ]
         │
         ├── Simpan instan ke LocalStorage browser
         └── Sync asinkron ke server via POST api.php?entity=...&period=YYYY-MM
```

---

### 4.3 Alur Siklus Industri NUP (`industrial.html`)

Alur hidup pekerjaan industri dimulai dari penerbitan NUP sampai penagihan lunas:

```
1. PENETAPAN NUP
   [Kontrak Masuk] ──▶ Buat NUP Baru (Nomor NUP, Customer, Nilai Kontrak, Target Selesai)
                              │
                              ▼
2. EKSEKUSI WORKSHOP & PENGELUARAN
   ├── Buat Workshop Jobs (Rencana Mulai, Rencana Selesai, Manpower)
   ├── Pengeluaran Proyek (Catat PO Vendor Bahan & Biaya Unik/Internal)
   └── Monitoring ATPA (Alat Bantu Kerja Khusus Proyek)
                              │
                              ▼
3. PROGRESS & EVALUASI KERJA
   ├── Update Progress Fisik (%)
   └── Jika tgl_plan_selesai terlewati ──▶ Tandai Late Schedule & Catat Alasan
                              │
                              ▼
4. PROSES PENAGIHAN (INVOICE CYCLE)
   [Terbit Tagihan/Termin] ──▶ Draft / Dikirim
                              │
                              ▼
   [Verifikasi Lapangan]   ──▶ Terbitkan BAL (Berita Acara Lapangan)
                              │
                              ▼
   [Serah Terima Resmi]   ──▶ Terbitkan BAST (Berita Acara Serah Terima)
                              │
                              ▼
5. PENYELESAIAN (SETTLEMENT)
   [Pembayaran Customer Masuk] ──▶ Status Tagihan: LUNAS
                              │
                              ▼
   [Kalkulasi Margin Otomatis] ──▶ Margin = Total Kontrak NUP - Total Pengeluaran (PO + Unik)
```

---

## 🗄️ Struktur Database (`wsbandung_db`)

Sistem menggunakan database MariaDB/MySQL bernama `wsbandung_db`.

### 1. Tabel Modul Dashboard WS Bandung
| Nama Tabel | Fungsi Utama | Kunci / Kolom Penting |
|---|---|---|
| `employees` | Data teknisi/karyawan per bulan | `id`, `period (YYYY-MM)`, `name`, `role`, `tags (JSON)`, `join_date`, `target_date` |
| `projects` | Master daftar proyek workshop | `id`, `period`, `name`, `client`, `start_date`, `end_date`, `status`, `sla_stage_id` |
| `sla_projects` | Data detail S-Curve dan tahapan SLA | `id`, `period`, `name`, `start_date`, `stages (JSON)` |
| `dashboard_data` | Key-value store fleksibel | `data_key`, `data_value (LONGTEXT)` |

### 2. Tabel Modul Industrial Services
| Nama Tabel | Fungsi Utama | Kunci / Kolom Penting |
|---|---|---|
| `nup` | Master Nomor Urut Pekerjaan / Kontrak | `id`, `nup_number (UNIQUE)`, `customer`, `nilai_kontrak`, `status` |
| `tagihan` | Faktur/Invoice bertahap per NUP | `id`, `nup_id`, `no_tagihan`, `nilai`, `status (draft, dikirim, bal, bast, lunas)` |
| `bal` | Dokumen Berita Acara Lapangan | `id`, `tagihan_id`, `no_bal`, `tgl_bal`, `diterima_oleh`, `file_path` |
| `bast` | Dokumen Berita Acara Serah Terima | `id`, `tagihan_id`, `bal_id`, `no_bast`, `tgl_bast`, `nilai_bast` |
| `workshop_job` | Pekerjaan fisik bengkel di bawah NUP | `id`, `nup_id`, `nama_pekerjaan`, `progress_pct`, `is_late`, `alasan_keterlambatan` |
| `atpa` | Registri alat bantu / tooling proyek | `id`, `nup_id`, `no_atpa`, `item`, `nilai`, `status` |
| `pengeluaran` | Realisasi biaya PO Vendor & biaya internal | `id`, `nup_id`, `jenis (po/unik)`, `no_po`, `nama_vendor`, `nilai`, `status_bayar` |

---

## 🔐 Role & Kontrol Hak Akses

Pada `dashboard.html`, diterapkan proteksi hak akses berbasis peran (*Role-Based Access Control*):

| Role | Password Default | Izin Akses Tab / Menu | Sifat Akses |
|---|---|---|---|
| **PPC** | `` | Karyawan, S-Curve SLA, Daftar Proyek, Summary Bulanan, Issue, Alarm | **Full Access** (Baca, Tulis, Edit, Hapus) |
| **HC** | `` | Karyawan, Summary Bulanan | **Read & Write** Data Karyawan |
| **PRODUKSI** | ``| S-Curve SLA, Daftar Proyek, Issue | **View-Only Mode** (Aksi penambahan/edit data dicegah dengan notifikasi visual) |

---

## 🚀 Panduan Instalasi & Menjalankan di Lokal

### Prasyarat
1. **XAMPP** (dengan Apache dan MySQL/MariaDB aktif, PHP versi 7.4 atau 8.x).
2. Browser modern (Chrome, Edge, Firefox) dengan JavaScript aktif.

### Langkah-langkah Setup
1. **Salin Berkas ke Direktori Web Server**:
   Tempatkan folder proyek ke dalam direktori root XAMPP:
   ```plaintext
   C:\xampp\htdocs\smartproduction\
   ```

2. **Buat Database & Import Skema**:
   - Buka browser dan akses `http://localhost/phpmyadmin/`.
   - Buat database baru bernama `wsbandung_db` dengan collation `utf8mb4_unicode_ci`.
   - Buka menu **Import**, pilih file [schema.sql](file:///c:/xampp/htdocs/smartproduction/schema.sql), lalu jalankan.
   - Jalankan pula migrasi kolom tahapan SLA jika belum ada: import [migration_add_sla_stage.sql](file:///c:/xampp/htdocs/smartproduction/migration_add_sla_stage.sql).

3. **Inisialisasi Tabel Industrial Services**:
   Jalankan skrip inisialisasi tabel industrial melalui browser:
   ```plaintext
   http://localhost/smartproduction/setup_industrial_tables.php
   ```
   Pastikan muncul respons JSON:
   `{"status":"success","message":"Tabel industrial services berhasil dipasang dan diverifikasi."}`

4. **Konfigurasi Database (`config.php`)**:
   Pastikan parameter koneksi pada [config.php](file:///c:/xampp/htdocs/smartproduction/config.php) sesuai dengan MySQL Anda:
   ```php
   define('DB_HOST', 'localhost');
   define('DB_NAME', 'wsbandung_db');
   define('DB_USER', 'root');
   define('DB_PASS', '');
   define('API_SECRET', 'c807f523f4d0eb3270c7cec7826ed25ed49e81915f6ec322');
   ```

5. **Akses Aplikasi**:
   - **Portal Utama**: `http://localhost/smartproduction/index.html`
   - **Dashboard WS Bandung**: `http://localhost/smartproduction/dashboard.html`
   - **Alur Industrial Services**: `http://localhost/smartproduction/industrial.html`

---

## 📡 Spesifikasi REST API

Seluruh permintaan mutasi data membutuhkan header otentikasi:
```http
X-Api-Key: c807f523f4d0eb3270c7cec7826ed25ed49e81915f6ec322
```

### 1. Endpoint WS Bandung (`api.php`)
- `GET api.php?entity=employees&year=YYYY`: Mengambil seluruh data karyawan untuk 12 bulan dalam tahun tertentu.
- `GET api.php?entity=employee_summary&year=YYYY`: Mengambil agregasi kinerja karyawan (tags + subtask SLA) selama setahun penuh.
- `GET api.php?entity=sla_projects&all=1`: Mengambil master data proyek S-Curve beserta tahapan subtask.
- `GET api.php?entity=projects&all=1`: Mengambil seluruh master proyek bengkel.
- `POST api.php?entity={employees|sla_projects|projects}&period=YYYY-MM`: Menyimpan array data JSON ke database dengan mekanisme transaksi per periode.

### 2. Endpoint Industrial Services (`industrial_api.php`)
- `GET industrial_api.php?action=summary`: Ringkasan eksekutif KPI (Total Kontrak, Tagihan, Pengeluaran, Margin, Workshop Late).
- `GET industrial_api.php?action=get_nups`: Daftar seluruh NUP dan akumulasi keuangannya.
- `POST industrial_api.php?action=save_nup`: Tambah atau ubah data NUP.
- `POST industrial_api.php?action=save_tagihan`: Buat tagihan/termin baru di bawah NUP.
- `POST industrial_api.php?action=save_bal`: Catat Berita Acara Lapangan untuk tagihan terkait.
- `POST industrial_api.php?action=save_bast`: Catat BAST resmi penyerahan pekerjaan.
- `POST industrial_api.php?action=save_workshop_job`: Buat/update pekerjaan workshop.
- `POST industrial_api.php?action=update_late_schedule`: Perbarui alasan keterlambatan pekerjaan workshop.
- `POST industrial_api.php?action=save_pengeluaran`: Catat biaya PO vendor atau pengeluaran internal bengkel.

---

## 🔧 Catatan Pemeliharaan & Troubleshooting

1. **Sinkronisasi Data Offline/Online**:
   Jika server database MySQL sempat mati, frontend tetap dapat berjalan menggunakan data yang tersimpan di `LocalStorage`. Ketika koneksi pulih, aksi simpan berikutnya akan menyelaraskan data kembali ke server.
2. **Format Periode Data**:
   Periode penyimpanan di database menggunakan format ISO `YYYY-MM`. Pada UI `dashboard.html`, pemilihan dilakukan secara tahunan (`Tahun 2026 (Jan–Des)`), di mana sistem secara cerdas mengarahkan penulisan baru ke bulan berjalan sistem.
3. **Audit Log & Bug**:
   Daftar perbaikan keamanan, sanitasi input SQL, dan rekomendasi arsitektur terdokumentasi lengkap di berkas [bugs.md](file:///c:/xampp/htdocs/smartproduction/bugs.md).

---

*Dikembangkan untuk PT Indopelita Aircraft Services – Workshop Bandung Operations & Industrial Services.*
