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

## Struktur Repository

```
PlanIt/
├── README.md              ← dokumentasi ini
├── final_project_mhs/     ← aplikasi Flutter (mobile)
└── planit-backend/        ← REST API backend (Node.js + Express.js)
```

---

## Framework & Library yang Digunakan

### Mobile (Flutter)
| Teknologi | Versi | Kegunaan |
|---|---|---|
| **Flutter** | ≥ 3.x | Framework utama aplikasi mobile cross-platform |
| **Dart** | ≥ 3.2.2 | Bahasa pemrograman |
| `http` | ^1.2.0 | Komunikasi HTTP ke REST API |
| `shared_preferences` | ^2.2.2 | Penyimpanan data lokal |
| `flutter_local_notifications` | ^17.0.0 | Notifikasi lokal pengingat acara |
| `timezone` | ^0.9.4 | Zona waktu untuk penjadwalan notifikasi |
| `image_picker` | ^1.0.8 | Akses galeri dan kamera |

### Backend (Express.js)
| Teknologi | Keterangan |
|---|---|
| **Node.js** ≥ 18 | Runtime JavaScript |
| **Express.js** | Framework REST API |
| **MySQL** | Database utama |
| `mysql2` | Driver koneksi MySQL |
| `jsonwebtoken` | Autentikasi JWT |
| `bcryptjs` | Hash password |

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

## Prasyarat

Pastikan sudah terinstall di komputer Anda:

| Tools | Versi | Download |
|---|---|---|
| Flutter SDK | ≥ 3.x | https://docs.flutter.dev/get-started/install |
| Android Studio / Emulator | API ≥ 21 | https://developer.android.com/studio |
| Node.js + npm | ≥ 18.x | https://nodejs.org |
| MySQL | - | https://dev.mysql.com/downloads atau via XAMPP/Laragon |
| git | 2.54.0 | https://git-scm.com/install/windows |

---

## Cara Menjalankan

### Langkah 1 — Clone Repository

pada terminal di VSCode
```bash
git clone https://github.com/Nazlanyusuf/Final_Project_MHS_Group11.git
cd Final_Project_MHS_Group11
```

---

### Langkah 2 — Setup Database

Buka phpMyAdmin atau MySQL CLI, buat database baru:

```sql
CREATE DATABASE planit_db;
```

---

### Langkah 3 — Setup Backend

pada terminal di VSCode
```bash
cd planit-backend

npm install

# Windows
copy .env.example .env

# Mac / Linux
cp .env.example .env
```

Buka file `.env` pada folder planit-backend dan sesuaikan:

```env
PORT=8000
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=planit_db
DB_USER=root
DB_PASS=           ← isi jika MySQL Anda pakai password
JWT_SECRET=planit_secret_key_123
```

Jalankan migrasi dan seeder:

```bash
npm run migrate    # membuat semua tabel
npm run seed       # mengisi data venue contoh
```

Jalankan server backend:

```bash
npm run dev
```

> Jika muncul **`Server berjalan di http://localhost:8000`**, backend sudah siap.

---

### Langkah 4 — Setup Flutter

Buka terminal baru (biarkan terminal backend tetap berjalan):

```bash
cd Final_Project_MHS_Group11\final_project_mhs

flutter pub get
```

---

### Langkah 5 — Konfigurasi URL API

URL backend sudah dikonfigurasi otomatis di `final_project_mhs/lib/services/auth_service.dart`:

| Platform | URL |
|---|---|
| Android Emulator | `http://10.0.2.2:8000` |
| Web / Windows / iOS | `http://localhost:8000` |

> **Perangkat fisik Android**: ubah URL menjadi IP komputer Anda di jaringan lokal,
> contoh: `http://192.168.1.10:8000`. Pastikan HP dan komputer terhubung ke WiFi yang sama.

---

### Langkah 6 — Jalankan Aplikasi Flutter

#### Emulator Android

```bash
flutter emulators                          # lihat daftar emulator
flutter emulators --launch <nama-emulator> # jalankan emulator
flutter run                                # jalankan aplikasi
```

#### Perangkat Fisik Android

1. Aktifkan **Developer Options** → **USB Debugging** di HP.
2. Sambungkan HP ke komputer via USB.
3. Jalankan:

```bash
flutter devices   # pastikan HP terdeteksi
flutter run
```

---

### Langkah 7 — Buat Akun

Buka aplikasi → klik **Register** → isi data → Login.

---

## Troubleshooting

| Masalah | Solusi |
|---|---|
| `Connection refused` saat login | Pastikan `npm run dev` di folder `planit-backend` sedang berjalan |
| Venue kosong di dashboard | Jalankan `npm run seed` di folder `planit-backend` |
| Emulator tidak terdeteksi | Jalankan `flutter doctor` dan ikuti instruksinya |
| `flutter pub get` gagal | Periksa koneksi internet dan pastikan Flutter SDK terinstall |
| Notifikasi tidak muncul | Izinkan notifikasi di Pengaturan → Aplikasi → PlanIt |
| Error di perangkat fisik | Pastikan IP di `auth_service.dart` sesuai IP komputer Anda |

---

## Dikembangkan Oleh

Proyek ini merupakan Final Project mata kuliah **Mobile dan Hybrid Solution (MHS)** — Semester 4.
