# PlanIt — Event Organizer & Venue Booking App

---

## Tentang Aplikasi

**PlanIt** adalah aplikasi mobile yang memudahkan pengguna dalam mencari, memilih, dan memesan venue serta jasa Event Organizer (EO) untuk berbagai jenis acara. Mulai dari pernikahan, konser, ulang tahun, seminar, hingga sesi foto, semua dapat direncanakan dan dipesan langsung melalui satu platform.

Nama "PlanIt" mencerminkan filosofi aplikasi: *plan it* (rencanakan) — segala kebutuhan acara Anda, direncanakan dengan mudah dan cepat.

---

## Latar Belakang

Proses pencarian dan pemesanan venue atau EO selama ini masih dilakukan secara manual — menghubungi satu per satu via telepon atau media sosial, membandingkan harga sendiri, dan mengurus konfirmasi melalui berbagai saluran yang berbeda. Proses ini memakan waktu, tidak efisien, dan rawan miskomunikasi.

Di sisi lain, pertumbuhan industri event di Indonesia terus meningkat, sementara platform digital yang secara khusus menjembatani antara pengguna akhir dengan penyedia jasa EO dan venue masih sangat terbatas.

**PlanIt** hadir sebagai solusi digital yang menyatukan seluruh proses — dari pencarian, perbandingan paket, pemesanan, pembayaran, hingga komunikasi langsung dengan EO — dalam satu aplikasi yang terintegrasi.

---

## Tujuan Aplikasi

1. **Memudahkan pencarian venue dan EO** berdasarkan kategori acara yang diinginkan pengguna.
2. **Menyederhanakan proses booking** dengan alur yang jelas: pilih venue → pilih paket → isi detail acara → konfirmasi pembayaran.
3. **Menyediakan fitur komunikasi langsung** antara pengguna dengan pihak EO melalui fitur chat terintegrasi.
4. **Memberikan transparansi** melalui sistem review dan rating yang dapat ditulis pengguna setelah menggunakan jasa.
5. **Membantu pengguna mengatur jadwal acara** melalui fitur pengingat (event reminder) berbasis notifikasi lokal.
6. **Memusatkan seluruh riwayat aktivitas** pengguna — booking, pembayaran, wishlist, review, dan chat — dalam satu halaman notifikasi terpadu.

---

## Framework & Library yang Digunakan

### Core
| Teknologi | Versi | Kegunaan |
|---|---|---|
| **Flutter** | ≥ 3.x | Framework utama pengembangan aplikasi mobile cross-platform |
| **Dart** | ≥ 3.2.2 | Bahasa pemrograman |

### Backend (terpisah)
| Teknologi | Keterangan |
|---|---|
| **Laravel** | REST API backend, berjalan di port `8000` |
| **MySQL** | Database untuk menyimpan data user, venue, booking, review |

### Flutter Dependencies
| Package | Versi | Kegunaan |
|---|---|---|
| `http` | ^1.2.0 | Komunikasi HTTP ke REST API Laravel |
| `shared_preferences` | ^2.2.2 | Penyimpanan data lokal (token auth, chat, wishlist, activity log) |
| `flutter_local_notifications` | ^17.0.0 | Notifikasi lokal untuk pengingat acara |
| `timezone` | ^0.9.4 | Pengelolaan zona waktu untuk penjadwalan notifikasi |
| `image_picker` | ^1.0.8 | Akses galeri dan kamera perangkat |

---

## Fitur Utama

- **Autentikasi** — Register, Login, Logout, ubah profil & password
- **Dashboard** — Browse venue/EO berdasarkan kategori, pencarian, promo banner
- **Detail Venue** — Informasi lengkap, paket harga, galeri, jumlah review
- **Booking** — Pilih paket, isi detail acara, konfirmasi pemesanan
- **Pembayaran** — Simulasi alur pembayaran dengan halaman sukses
- **Wishlist** — Simpan venue favorit ke dalam koleksi pribadi
- **Chat** — Kirim pesan langsung ke EO, riwayat chat tersimpan per venue
- **Review** — Tulis ulasan dan rating setelah memakai jasa EO
- **Notifikasi** — Activity log seluruh aktivitas (booking, bayar, review, wishlist, chat)
- **Event Reminder** — Atur pengingat acara dengan notifikasi lokal terjadwal
- **Profile** — Lihat statistik booking, wishlist, review; akses riwayat review

---

## Tahap Setup & Cara Menjalankan

### Prasyarat

Pastikan perangkat atau komputer sudah memiliki:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi ≥ 3.x)
- [Dart SDK](https://dart.dev/get-dart) (sudah termasuk dalam Flutter SDK)
- [Android Studio](https://developer.android.com/studio) atau emulator Android (API level ≥ 21)
- [PHP](https://www.php.net/downloads) ≥ 8.1 dan [Composer](https://getcomposer.org/) (untuk backend Laravel)
- [MySQL](https://dev.mysql.com/downloads/) atau XAMPP / Laragon

---

### 1. Clone Repository

```bash
git clone <url-repository-ini>
cd final_project_mhs
```

---

### 2. Setup Backend Laravel

> Backend Laravel berada di repository / folder terpisah.

```bash
# Masuk ke folder backend
cd <folder-backend-laravel>

# Install dependency PHP
composer install

# Salin file environment
cp .env.example .env

# Generate application key
php artisan key:generate
```

Edit file `.env` dan sesuaikan konfigurasi database:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=planit_db
DB_USERNAME=root
DB_PASSWORD=
```

Lanjutkan setup database:

```bash
# Jalankan migrasi
php artisan migrate

# (Opsional) Isi data awal / seeder
php artisan db:seed

# Jalankan server Laravel
php artisan serve
```

Server akan berjalan di `http://127.0.0.1:8000`.

---

### 3. Setup Flutter App

```bash
# Kembali ke folder Flutter
cd final_project_mhs

# Install semua package Flutter
flutter pub get
```

---

### 4. Konfigurasi URL API

URL backend sudah dikonfigurasi otomatis di `lib/services/auth_service.dart`:

| Platform | URL yang Digunakan |
|---|---|
| Android Emulator | `http://10.0.2.2:8000` |
| Web / Windows / iOS | `http://localhost:8000` |

> Jika menggunakan **perangkat fisik Android**, ubah URL di file `auth_service.dart` menjadi IP lokal komputer Anda (contoh: `http://192.168.1.10:8000`) dan pastikan perangkat berada dalam jaringan WiFi yang sama dengan komputer.

---

### 5. Jalankan Aplikasi

#### Menggunakan Emulator Android

```bash
# Cek emulator yang tersedia
flutter emulators

# Jalankan emulator
flutter emulators --launch <nama-emulator>

# Jalankan aplikasi
flutter run
```

#### Menggunakan Perangkat Fisik Android

1. Aktifkan **Developer Options** dan **USB Debugging** di perangkat.
2. Sambungkan perangkat ke komputer via USB.
3. Jalankan:

```bash
flutter devices      # Pastikan perangkat terdeteksi
flutter run
```

---

### 6. Akun untuk Testing

Daftarkan akun baru melalui halaman **Register** di aplikasi, atau gunakan akun yang sudah dibuat via seeder (jika tersedia di backend).

---

### Troubleshooting Umum

| Masalah | Solusi |
|---|---|
| `Connection refused` saat login/register | Pastikan `php artisan serve` sedang berjalan |
| Emulator tidak terdeteksi | Jalankan `flutter doctor` untuk cek instalasi |
| `flutter pub get` gagal | Pastikan koneksi internet aktif dan Flutter SDK ter-install dengan benar |
| Notifikasi tidak muncul | Izinkan notifikasi di pengaturan aplikasi Android |
| Venue tidak muncul di dashboard | Pastikan seeder sudah dijalankan di backend |

---

## Struktur Folder (Flutter)

```
lib/
├── main.dart                   # Entry point aplikasi
├── main_navigation.dart        # Bottom navigation bar utama
├── pages/
│   ├── auth/                   # Login, Register
│   ├── dashboard/              # Halaman utama / beranda
│   ├── booking/                # Detail venue & form booking
│   ├── payment/                # Halaman pembayaran & sukses
│   ├── chat/                   # Daftar chat & pesan
│   ├── profile/                # Profil, info personal, riwayat review
│   ├── reminders/              # Pengingat acara
│   ├── activity.dart           # Riwayat booking (Activity)
│   ├── wishlist.dart           # Halaman wishlist
│   ├── notification_page.dart  # Activity log / notifikasi
│   └── search_page.dart        # Pencarian venue
├── services/                   # Logika komunikasi API & data lokal
├── widgets/                    # Komponen UI reusable
└── utils/                      # Helper & utility
```

---

## Dikembangkan Oleh

Proyek ini merupakan Final Project mata kuliah **Mobile dan Hybrid Solution (MHS)** — Semester 4.
