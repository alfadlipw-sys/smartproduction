# 🐛 Bug Report — Workshop Operations Dashboard (wsbandung)

> Hasil audit kode pada [index.html](file:///d:/Kerja/wsbandung/index.html), [api.php](file:///d:/Kerja/wsbandung/api.php), [config.php](file:///d:/Kerja/wsbandung/config.php), dan [schema.sql](file:///d:/Kerja/wsbandung/schema.sql).
> Tanggal audit: 24 Juli 2026

---

## 🔴 CRITICAL — Keamanan (Security)

### BUG-01: API Secret di-hardcode di client-side (XSS → Full API Access)

| Item | Detail |
|------|--------|
| **File** | [index.html L2545](file:///d:/Kerja/wsbandung/index.html#L2545), [config.php L12](file:///d:/Kerja/wsbandung/config.php#L12) |
| **Masalah** | API key `c807f523f4d0eb3270c7cec7826ed25ed49e81915f6ec322` di-embed langsung dalam HTML/JS: `window.API_SECRET = 'c807f523f...'`. Siapa pun yang view source dapat melihat dan menggunakan key ini untuk mengakses seluruh API (CRUD employees, projects, SLA data). |
| **Dampak** | Semua data bisa dibaca, dimodifikasi, atau dihapus oleh pihak luar tanpa autentikasi. |
| **Rekomendasi** | Gunakan session-based authentication (cookies HttpOnly) atau token JWT. Jangan pernah embed secret di client-side code. |

---

### BUG-02: SQL Injection melalui nama entity

| Item | Detail |
|------|--------|
| **File** | [api.php L96](file:///d:/Kerja/wsbandung/api.php#L96), [L122](file:///d:/Kerja/wsbandung/api.php#L122) |
| **Masalah** | Variabel `$entity` diinterpolasi langsung ke SQL query tanpa parameterisasi: `"SELECT * FROM $entity WHERE period = ?"` dan `"DELETE FROM $entity WHERE period = ?"`. Meskipun ada whitelist check (`in_array($entity, $ENTITIES)`), ini adalah pola rawan — jika di kemudian hari whitelist diubah atau bypass terjadi, ini menjadi SQL injection. |
| **Dampak** | Saat ini mitigasi oleh whitelist, tapi rawan jika kode berubah. Tidak best-practice. |
| **Rekomendasi** | Gunakan mapping entity→table name yang explicit, bukan interpolasi langsung ke SQL. |

---

### BUG-03: Login plaintext tanpa hashing

| Item | Detail |
|------|--------|
| **File** | [index.html L2670-L2674](file:///d:/Kerja/wsbandung/index.html#L2670-L2674), [L4295](file:///d:/Kerja/wsbandung/index.html#L4295) |
| **Masalah** | Username dan password di-hardcode di client-side JavaScript: `HC: { password: 'HC2026' }`, `PRODUKSI: { password: 'PRODUKSI2026' }`, `PPC: { password: 'PPC2026' }`. Password dicompare secara plaintext di client. |
| **Dampak** | Siapa pun yang view source mendapatkan semua credential. Sistem autentikasi sepenuhnya bypassable. |
| **Rekomendasi** | Pindahkan autentikasi ke server-side (PHP) dengan password hashing (`password_hash`/`password_verify`). |

---

### BUG-04: XSS via `innerHTML` tanpa sanitasi

| Item | Detail |
|------|--------|
| **File** | Banyak lokasi di [index.html](file:///d:/Kerja/wsbandung/index.html), contoh: [L2965](file:///d:/Kerja/wsbandung/index.html#L2965), [L3833](file:///d:/Kerja/wsbandung/index.html#L3833), [L3893](file:///d:/Kerja/wsbandung/index.html#L3893), [L4032](file:///d:/Kerja/wsbandung/index.html#L4032) |
| **Masalah** | User-input seperti nama karyawan (`emp.name`), deskripsi subtask (`t.desc`), nama proyek (`p.name`), tag label (`t.label`), dan nama client (`p.client`) dimasukkan langsung ke `innerHTML` melalui template literals tanpa HTML escaping. |
| **Dampak** | Stored XSS — pengguna bisa memasukkan `<script>` tag atau event handler di field input yang kemudian dieksekusi saat data ditampilkan. |
| **Rekomendasi** | Buat helper function `escapeHtml()` dan gunakan pada semua user-input sebelum dimasukkan ke `innerHTML`. |

---

## 🟠 HIGH — Bug Logika dan Data Integrity

### BUG-05: Subtask format lama (`emp` string) tidak kompatibel saat menambah subtask baru

| Item | Detail |
|------|--------|
| **File** | [index.html L3888](file:///d:/Kerja/wsbandung/index.html#L3888), [L3926](file:///d:/Kerja/wsbandung/index.html#L3926) |
| **Masalah** | Data lama di database menggunakan format `emp: "Haris"` (string tunggal, kadang berisi banyak nama dipisahkan koma: `emp: "Diki, Cepi"`). Data baru menggunakan `emps: ["Diki", "Cepi"]` (array). Rendering sudah handle kedua format di [L3888](file:///d:/Kerja/wsbandung/index.html#L3888): `const empList = (t.emps && t.emps.length) ? t.emps : (t.emp ? [t.emp] : [])`. **Namun**, untuk data lama dengan format `emp: "Diki, Cepi"`, ini menghasilkan array `["Diki, Cepi"]` — satu elemen berisi dua nama. Akibatnya, pencarian karyawan di `empList.includes(emp.name)` untuk "Diki" atau "Cepi" secara individual **akan gagal** (return false), sehingga subtask tidak muncul di dashboard individu mereka. |
| **Dampak** | Karyawan yang ditugaskan lewat format lama (multi-nama dalam satu string) tidak terdeteksi di dashboard individual dan kartu SLA per karyawan. |
| **Rekomendasi** | Saat membaca `emp` (string), split by koma: `t.emp ? t.emp.split(',').map(s => s.trim()) : []`. |

---

### BUG-06: `recalcStageActualPct` membulatkan dan memotong progress subtask

| Item | Detail |
|------|--------|
| **File** | [index.html L4422-L4430](file:///d:/Kerja/wsbandung/index.html#L4422-L4430) |
| **Masalah** | Fungsi `recalcStageActualPct` menghitung total bobot subtask selesai: `Math.min(100, Math.round(sum))`. Ini menggunakan `Math.round` yang membulatkan, sehingga jika total bobot subtask selesai = 99.5%, maka `actualPct` menjadi 100% dan status otomatis berubah ke "Selesai" meskipun belum sepenuhnya selesai. |
| **Dampak** | Status tahapan bisa salah menunjukkan "Selesai" padahal masih ada subtask pending. |
| **Rekomendasi** | Gunakan `Math.floor(sum)` untuk memastikan 100% hanya tercapai ketika semua bobot benar-benar 100. |

---

### BUG-07: Stage status otomatis di-overwrite ke "Terlambat" saat build tabel `[FIXED]`

| Item | Detail |
|------|--------|
| **Status** | ✅ **FIXED** (Diperbaiki di [index.html L3732-L3783](file:///d:/Kerja/wsbandung/index.html#L3732-L3783)) |
| **File** | [index.html L3732-L3737](file:///d:/Kerja/wsbandung/index.html#L3732-L3737) |
| **Masalah** | Di fungsi `buildSLATable`, jika status adalah "On-Progres" dan sudah melewati deadline, status otomatis diubah ke "Terlambat" (`s.statusState = 'Terlambat'`). Perubahan ini sebelumnya tidak disimpan via `saveCurrentSlaState()`, sehingga setelah reload status kembali ke "On-Progres". |
| **Solusi** | Ditambahkan flag `hasStateChanged` pada `buildSLATable()`. Jika ada tahapan yang terdeteksi terlambat dan di-update statusnya ke `Terlambat`, fungsi akan memanggil `saveCurrentSlaState()` untuk menyimpan perubahan ke localStorage dan server database. |

---

### BUG-08: `generateSCurve` me-overwrite `stages.status` (computed vs manual)

| Item | Detail |
|------|--------|
| **File** | [index.html L3547-L3553](file:///d:/Kerja/wsbandung/index.html#L3547-L3553) |
| **Masalah** | Setiap kali `generateSCurve` dipanggil, `s.status` di-recalculate berdasarkan tanggal saat ini (pending/done/ongoing/overdue). Ini menimpa nilai `status` yang mungkin sudah disimpan dari database. Field `status` dan `statusState` memiliki peran yang tumpang tindih dan membingungkan. |
| **Dampak** | Nilai `s.status` yang tersimpan di JSON database tidak bermakna karena selalu di-overwrite. Namun beberapa bagian kode masih membaca `s.status` (bukan `s.statusState`). |
| **Rekomendasi** | Konsolidasikan menjadi satu field status saja, atau beri nama berbeda untuk computed vs manual status. |

---

### BUG-09: `saveEmpData()` menyimpan ke key generik yang bisa menimpa antar-periode

| Item | Detail |
|------|--------|
| **File** | [index.html L2909-L2914](file:///d:/Kerja/wsbandung/index.html#L2909-L2914) |
| **Masalah** | `saveEmpData()` menyimpan data ke 2 key: `ias_employee_data_${currentPeriod}` (benar) **dan** `ias_employee_data` (generik). Di `loadData()` [L2890](file:///d:/Kerja/wsbandung/index.html#L2890), key generik digunakan sebagai fallback. Ini berarti jika user mengubah data di periode Juli, lalu membuka periode Agustus yang kosong, data Juli akan otomatis di-copy ke Agustus — potensi duplikasi/kontaminasi data antar-periode. |
| **Dampak** | Data karyawan bisa bocor antar-periode secara tak terduga. |
| **Rekomendasi** | Hapus penyimpanan ke key generik `ias_employee_data`. Gunakan mekanisme eksplisit "Salin dari Periode Lain" jika diinginkan. |

---

### BUG-10: `toggleSubtask` tidak cek apakah `s.subtasks[idx]` ada

| Item | Detail |
|------|--------|
| **File** | [index.html L4412-L4420](file:///d:/Kerja/wsbandung/index.html#L4412-L4420) |
| **Masalah** | `toggleSubtask` melakukan `s.subtasks[idx].isDone = checked` tanpa memeriksa apakah `s.subtasks` dan `s.subtasks[idx]` ada. Jika subtask dihapus oleh user lain (multi-tab) sementara tampilan belum di-refresh, ini akan throw error `Cannot set properties of undefined`. |
| **Dampak** | Crash JavaScript jika index out of bounds. |
| **Rekomendasi** | Tambahkan guard: `if (s && s.subtasks && s.subtasks[idx])`. |

---

### BUG-11: `isoDate()` menggunakan UTC yang bisa salah 1 hari

| Item | Detail |
|------|--------|
| **File** | [index.html L2665](file:///d:/Kerja/wsbandung/index.html#L2665) |
| **Masalah** | `function isoDate(d) { return d.toISOString().split('T')[0]; }` menggunakan `toISOString()` yang mengonversi ke UTC. Untuk timezone WIB (UTC+7), tanggal `2026-07-24 01:00 WIB` menjadi `2026-07-23` di UTC. Ini bisa menyebabkan tanggal input di form bergeser mundur 1 hari. |
| **Dampak** | Tanggal di form dan kalkulasi bisa salah ±1 hari tergantung waktu input. |
| **Rekomendasi** | Gunakan local date formatting: `d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0')`. |

---

## 🟡 MEDIUM — Bug Fungsional

### BUG-12: `goToSlaProject` menggunakan index proyek yang bisa berubah

| Item | Detail |
|------|--------|
| **File** | [index.html L4576-L4593](file:///d:/Kerja/wsbandung/index.html#L4576-L4593) |
| **Masalah** | `goToSlaProject(projIndex)` menerima index array. Jika proyek ditambah/dihapus antara waktu render Issue tab dan klik, index bisa menunjuk ke proyek yang salah. |
| **Dampak** | Navigasi ke proyek yang salah dari Issue tab. |
| **Rekomendasi** | Gunakan project `id` bukan array index. |

---

### BUG-13: Proyek di-edit via `contenteditable` → tanggal format rusak

| Item | Detail |
|------|--------|
| **File** | [index.html L4034-L4035](file:///d:/Kerja/wsbandung/index.html#L4034-L4035) |
| **Masalah** | Tanggal Start dan End ditampilkan dalam format DD/MM/YYYY via `formatDMY()`, lalu kolom dibuat `contenteditable`. Saat user mengedit, `onblur` menyimpan teks mentah (DD/MM/YYYY) ke field `start`/`end`. Tapi fungsi `calcDaysLeft()` [L3990](file:///d:/Kerja/wsbandung/index.html#L3990) menggunakan `new Date(endStr)` yang mengharapkan format ISO (YYYY-MM-DD). `new Date("24/07/2026")` menghasilkan `Invalid Date`. |
| **Dampak** | "Days Left" selalu menunjukkan 0 setelah user mengedit tanggal, kalkulasi S-Curve bisa error. |
| **Rekomendasi** | Gunakan `<input type="date">` bukan `contenteditable` untuk kolom tanggal, atau parse format DD/MM/YYYY sebelum menyimpan. |

---

### BUG-14: `renderIssueAndAlarm` memanggil `getSlaProjects()` tiga kali

| Item | Detail |
|------|--------|
| **File** | [index.html L4438](file:///d:/Kerja/wsbandung/index.html#L4438), [L4512](file:///d:/Kerja/wsbandung/index.html#L4512), [L4532](file:///d:/Kerja/wsbandung/index.html#L4532), [L4546](file:///d:/Kerja/wsbandung/index.html#L4546) |
| **Masalah** | Fungsi `renderIssueAndAlarm` memanggil `getSlaProjects()` empat kali (variabel `projs`, `projs2`, `projs` lagi di scope baru, dan `projs3`). Setiap panggilan melakukan `JSON.parse` dari localStorage. Selain pemborosan performa, variabel `projs` di [L4532](file:///d:/Kerja/wsbandung/index.html#L4532) men-shadow variabel `projs` yang sudah ada dari [L4439](file:///d:/Kerja/wsbandung/index.html#L4439). |
| **Dampak** | Performa buruk dan kode sulit di-maintain. |
| **Rekomendasi** | Panggil `getSlaProjects()` sekali saja di awal fungsi dan re-use hasilnya. |

---

### BUG-15: `openEditModal` menggunakan `innerHTML +=` dalam loop

| Item | Detail |
|------|--------|
| **File** | [index.html L3813-L3820](file:///d:/Kerja/wsbandung/index.html#L3813-L3820) |
| **Masalah** | `container.innerHTML += ...` dalam loop `forEach` menyebabkan DOM di-parse ulang setiap iterasi. Jika ada event listener di elemen sebelumnya, mereka akan hilang. Juga berpotensi isu performa. |
| **Dampak** | Kehilangan event listeners, performa DOM lambat. |
| **Rekomendasi** | Build string HTML lengkap lalu assign sekali: `container.innerHTML = allHTML`. |

---

### BUG-16: Subtask bobot bisa melebihi 100% total tanpa warning

| Item | Detail |
|------|--------|
| **File** | [index.html L3910](file:///d:/Kerja/wsbandung/index.html#L3910), [L3922](file:///d:/Kerja/wsbandung/index.html#L3922) |
| **Masalah** | Total bobot subtask dalam satu tahapan bisa melebihi 100% (misal: subtask 1 = 60%, subtask 2 = 70% = total 130%). Tidak ada validasi yang mencegah ini. `recalcStageActualPct` menggunakan `Math.min(100, ...)` untuk cap di 100, tapi user tetap bisa bingung kenapa semua subtask selesai tapi progress hanya 100%. |
| **Dampak** | Bobot tidak masuk akal, kalkulasi progress bisa misleading. |
| **Rekomendasi** | Tambahkan validasi warning saat total bobot melebihi 100%. |

---

### BUG-17: Mobile redirect loop potential

| Item | Detail |
|------|--------|
| **File** | [index.html L4307-L4316](file:///d:/Kerja/wsbandung/index.html#L4307-L4316) |
| **Masalah** | Kode redirect mobile: `location.href.replace('index.html', 'mobile-scurve.html')`. Jika URL tidak mengandung "index.html" (misalnya akses via `localhost:8000/?tab=scurve&sd=...`), `replace` tidak mengubah apa-apa dan halaman tidak redirect. Sebaliknya, file `mobile-scurve.html` **tidak ada** di project. |
| **Dampak** | Redirect mobile tidak berfungsi karena target file tidak ada. Pada URL tanpa "index.html", redirect juga tidak bekerja. |
| **Rekomendasi** | Buat file `mobile-scurve.html` atau hapus fitur redirect mobile. Perbaiki URL construction agar tidak bergantung pada presence string "index.html". |

---

## 🔵 LOW — Isu Minor dan UX

### BUG-18: `dashboard_data` table di schema tidak punya `AUTO_INCREMENT` dan `PRIMARY KEY` yang benar

| Item | Detail |
|------|--------|
| **File** | [schema.sql L33-L38](file:///d:/Kerja/wsbandung/schema.sql#L33-L38) |
| **Masalah** | Tabel `dashboard_data` di schema baru memiliki `id int(11) NOT NULL` **tanpa** `AUTO_INCREMENT` dan tanpa `PRIMARY KEY` di-define di CREATE TABLE statement. Tabel ini juga tidak punya `UNIQUE KEY` pada `data_key` — berbeda dari schema lama yang punya keduanya. Tabel ini tampak tidak digunakan lagi oleh kode API yang sudah beralih ke tabel terpisah, tapi tetap ada di schema. |
| **Dampak** | Tabel orphan tanpa primary key proper. |
| **Rekomendasi** | Hapus tabel `dashboard_data` jika sudah tidak digunakan, atau perbaiki schema-nya. |

---

### BUG-19: Evidence file disimpan sebagai Base64 di kolom database

| Item | Detail |
|------|--------|
| **File** | [api.php L168-L169](file:///d:/Kerja/wsbandung/api.php#L168-L169), [schema.sql — projects table](file:///d:/Kerja/wsbandung/schema.sql) |
| **Masalah** | Evidence file disimpan sebagai data URL (Base64) di kolom `evidence_data` (tipe `LONGTEXT`). File besar (gambar, PDF) akan menghasilkan string Base64 yang sangat besar, membebani database dan localStorage. |
| **Dampak** | Database bloat, `localStorage` bisa penuh (limit ~5-10MB), sync lambat. |
| **Rekomendasi** | Simpan file evidence ke server filesystem dan hanya simpan path di database. |

---

### BUG-20: Tidak ada CORS header di API

| Item | Detail |
|------|--------|
| **File** | [api.php](file:///d:/Kerja/wsbandung/api.php) |
| **Masalah** | API tidak menangani preflight `OPTIONS` request dan tidak mengirim CORS headers. Jika dashboard diakses dari domain berbeda dari API, browser akan memblokir request. |
| **Dampak** | API tidak bisa diakses cross-origin. Saat ini tidak masalah karena same-origin, tapi akan jadi masalah jika deployed ke domain berbeda. |
| **Rekomendasi** | Tambahkan `Access-Control-Allow-Origin` dan handle `OPTIONS` method. |

---

### BUG-21: Data loss jika 2 tab terbuka bersamaan (race condition)

| Item | Detail |
|------|--------|
| **File** | [api.php L122](file:///d:/Kerja/wsbandung/api.php#L122), [index.html L2910](file:///d:/Kerja/wsbandung/index.html#L2910) |
| **Masalah** | Strategi penyimpanan adalah "DELETE all + INSERT all" per periode. Jika 2 user/tab menyimpan data hampir bersamaan, satu set data akan menimpa yang lain secara keseluruhan. Tidak ada optimistic locking atau versioning. |
| **Dampak** | Data bisa hilang tanpa warning saat multiple users menggunakan dashboard. |
| **Rekomendasi** | Implementasi optimistic concurrency control (misal: timestamp/version check sebelum save). |

---

## 📊 Ringkasan

| Severity | Jumlah | Bug IDs |
|----------|--------|---------|
| 🔴 Critical | 4 | BUG-01, BUG-02, BUG-03, BUG-04 |
| 🟠 High | 7 | BUG-05 s/d BUG-11 |
| 🟡 Medium | 6 | BUG-12 s/d BUG-17 |
| 🔵 Low | 4 | BUG-18 s/d BUG-21 |
| **Total** | **21** | |

> [!IMPORTANT]
> Bug paling kritis yang harus segera diperbaiki adalah **BUG-01** (API secret terekspos), **BUG-03** (credentials plaintext), dan **BUG-11** (tanggal bergeser karena UTC). Ketiganya berdampak langsung pada keamanan dan kebenaran data operasional harian.
