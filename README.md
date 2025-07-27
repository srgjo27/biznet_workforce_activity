# Biznet Workforce Activity

Aplikasi mobile berbasis Flutter yang dirancang untuk tim teknisi lapangan Biznet. Aplikasi ini berfungsi sebagai alat untuk mencatat, mengelola, dan memonitor aktivitas harian mereka secara efisien dan transparan. Semua data aktivitas tersimpan secara real-time di Cloud Firestore, memungkinkan manajemen dan tim teknisi untuk mengakses data dari berbagai lokasi, sehingga meningkatkan efisiensi kerja.

## Fitur Utama

- Manajemen Aktivitas (CRUD): Pengguna dapat menambah, melihat daftar, memperbarui (edit), dan menghapus catatan aktivitas harian.
- Penandaan Status: Aktivitas dapat ditandai dengan status seperti "Sedang Dikerjakan" atau "Selesai".
- Pencatatan Waktu Otomatis: Waktu mulai (jamMulai) dicatat saat aktivitas dibuat, dan waktu selesai (jamSelesai) dicatat secara otomatis ketika status diubah menjadi "Selesai".
- Pencatatan Geolokasi: Setiap kali aktivitas dibuat atau diedit, aplikasi akan secara otomatis menangkap dan menyimpan posisi geografis (latitude & longitude) terkini.
- Sinkronisasi Real-time: Seluruh data disimpan dan disinkronkan secara langsung dengan Cloud Firestore.
- Pemeriksaan Izin: Aplikasi akan memeriksa dan meminta izin yang diperlukan (koneksi internet & lokasi) saat pertama kali dijalankan.

## Arsitektur & Teknologi

Aplikasi ini dibangun dengan arsitektur yang bersih, modular, dan terstruktur.

- Framework: Flutter.
- Database: Cloud Firestore.
- Arsitektur: Clean Architecture dengan pemisahan menjadi lapisan Data, Domain, dan Presentation.
- State Management: BLoC (Business Logic Component) untuk mengelola state aplikasi secara efisien dan terstruktur.
- Dependency Injection: get_it untuk mengelola dan menyediakan dependency ke seluruh aplikasi.
- Lainnya: geolocator untuk GPS, connectivity_plus untuk cek koneksi, intl untuk format tanggal, permission_handler untuk izin akses platform.

## Syarat

- Versi Flutter 3.32.7 atau dapat menggunakan fvm

## Instalasi dan Menjalankan

- Clone Repository: https://github.com/srgjo27/biznet_workforce_activity.git
- Buka direktori proyek di text editor seperti Visual Studio Code, Android Stuido, Cursor AI, dll.
- Lakukan flutter pub get untuk mengunduh semua depedensi yang digunakan.
- Lakukan flutter run untuk menjalankan aplikasi pada emulator atau perangkat hp.
- Lakukan flutter build apk --release untuk melakukan build bundle dalam ektensi .apk
- Build akan tersedia di build/app/outputs/flutter-apk/app-release.apk
