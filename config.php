<?php
// Konfigurasi koneksi database untuk dashboard wsbandung.
// Kredensial default XAMPP (MySQL lokal tanpa password).

define('DB_HOST', 'localhost');
define('DB_NAME', 'wsbandung_db');
define('DB_USER', 'root');
define('DB_PASS', '');

// Shared secret yang harus dikirim client lewat header X-Api-Key.
// Nilai ini juga di-embed di index.html (window.API_SECRET) agar cocok.
define('API_SECRET', 'c807f523f4d0eb3270c7cec7826ed25ed49e81915f6ec322');

function getDb(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
            DB_USER,
            DB_PASS,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
    }
    return $pdo;
}
