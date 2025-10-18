# Budget Mate

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

Aplikasi Manajemen Keuangan Pribadi yang Sederhana dan Kuat. Budget Mate membantu Anda untuk melacak pemasukan dan pengeluaran, mengelola anggaran, dan mencapai tujuan finansial Anda dengan antarmuka yang bersih dan mudah digunakan.

## 📸 Tangkapan Layar

*(Catatan: Anda bisa mengganti gambar ini dengan tangkapan layar asli dari aplikasi Anda)*

<div align="center">
  <img src="https://placehold.co/300x600/4CAF50/FFFFFF?text=Home+Screen" alt="Laman Beranda" width="200"/>
  <img src="https://placehold.co/300x600/2196F3/FFFFFF?text=Add+Transaction" alt="Tambah Transaksi" width="200"/>
  <img src="https://placehold.co/300x600/FF9800/FFFFFF?text=Reports" alt="Laporan" width="200"/>
</div>

## ✨ Fitur

-   **📝 Tambah dan Kelola Transaksi:** Catat dengan mudah setiap pemasukan dan pengeluaran Anda.
-   **🏷️ Kategori Kustom:** Buat dan kelola kategori sendiri untuk mengelompokkan transaksi.
-   **📊 Laporan Visual:** Lihat grafik dan statistik keuangan Anda untuk pemahaman yang lebih baik.
-   **💾 Penyimpanan Data Lokal:** Semua data Anda disimpan secara aman di perangkat menggunakan database SQLite.
-   **🎨 Antarmuka Modern:** Desain yang bersih, intuitif, dan menyenangkan untuk digunakan.
-   **🌙 Mode Tema:** Nikmati kenyamanan mode terang dan gelap (jika diimplementasikan).

## 🛠️ Tumpukan Teknologi (Tech Stack)

Aplikasi ini dibangun dengan teknologi terkini untuk memastikan performa dan pengalaman pengguna yang terbaik.

-   **Framework:** [Flutter](https://flutter.dev/)
-   **Bahasa:** [Dart](https://dart.dev/)
-   **Manajemen State:** [BLoC (Business Logic Component)](https://bloclibrary.dev/)
-   **Database:** [SQLite](https://www.sqlite.org/) (melalui paket [`sqflite`](https://pub.dev/packages/sqflite))
-   **Persistensi Lokal:** [`SharedPreferences`](https://pub.dev/packages/shared_preferences)
-   **Font:** [`Google Fonts`](https://pub.dev/packages/google_fonts)

## 🚀 Cara Memulai (Getting Started)

Untuk menjalankan proyek ini secara lokal di komputer Anda, ikuti langkah-langkah berikut:

### Prasyarat

Sebelum memulai, pastikan Anda telah menginstal:

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi terbaru)
-   Editor kode seperti [VS Code](https://code.visualstudio.com/) atau [Android Studio](https://developer.android.com/studio)
-   Emulator Android/iOS atau perangkat fisik untuk pengujian

### Instalasi

1.  **Clone repository ini ke komputer Anda:**
    ```bash
    git clone https://github.com/rizkyhibatullah/budget_mate.git
    ```

2.  **Masuk ke direktori proyek:**
    ```bash
    cd budget_mate
    ```

3.  **Install semua dependensi yang diperlukan:**
    ```bash
    flutter pub get
    ```

4.  **Jalankan aplikasi:**
    Pastikan emulator atau perangkat Anda sudah berjalan, lalu ketik perintah berikut:
    ```bash
    flutter run
    ```

## 📁 Struktur Proyek

Struktur direktori `lib` diorganisasikan sebagai berikut untuk memudahkan pengembangan dan pemeliharaan:
