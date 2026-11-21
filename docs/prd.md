# Product Requirements Document: Favorit Web

| Atribut | Nilai |
|---|---|
| Status | MVP |
| Platform | Android dan web |
| Bahasa antarmuka | Indonesia |
| Pemilik produk | Belum ditentukan |

## 1. Ringkasan produk

Favorit Web adalah aplikasi sederhana untuk mengelola kumpulan situs web pribadi.
Pengguna dapat melihat situs bawaan, menambahkan situs lain, mengubah nama atau
URL, menghapus situs, dan membuka situs melalui browser. Data favorit disimpan
secara lokal pada perangkat atau browser pengguna.

## 2. Masalah dan peluang

Pengguna memerlukan cara cepat untuk menyimpan dan membuka beberapa situs yang
sering dikunjungi tanpa harus mengingat atau mengetik ulang alamatnya. Aplikasi
ini menyediakan daftar favorit yang sederhana dan dapat disesuaikan.

## 3. Tujuan

- Menampilkan situs favorit dalam daftar yang mudah dipindai.
- Memungkinkan pengguna menambah, mengedit, dan menghapus situs.
- Mempertahankan daftar setelah aplikasi ditutup dan dibuka kembali.
- Membuka alamat situs yang dipilih melalui browser.
- Menyediakan pengalaman MVP yang sama pada Android dan web.

### Di luar cakupan

- Akun pengguna, sinkronisasi cloud, atau berbagi daftar.
- Penjelajahan situs di dalam aplikasi.
- Pengelompokan, pencarian, impor, atau ekspor favorit.
- Analitik penggunaan situs.

## 4. Pengguna sasaran

Pengguna yang ingin menyimpan dan membuka situs web pribadi dari satu daftar,
serta mengubah daftar tersebut tanpa pengaturan yang rumit.

## 5. Situs bawaan

Pada penggunaan pertama, daftar berisi:

| Nama | URL |
|---|---|
| ninofelino12.github.io | `https://ninofelino12.github.io` |
| ninofelino.github.io | `https://ninofelino.github.io` |
| Docker Hub | `https://hub.docker.com` |

Situs bawaan hanya digunakan jika belum ada data favorit tersimpan. Jika
pengguna menghapus semua situs, daftar tetap kosong saat aplikasi dibuka lagi.

## 6. Kebutuhan fungsional

### F-01 — Menampilkan daftar favorit

- Tampilkan nama dan URL setiap favorit sebagai kartu yang dapat diketuk.
- Tampilkan jumlah situs yang tersimpan.
- Saat belum ada favorit, tampilkan pesan bahwa daftar kosong dan ajakan untuk
  menambah situs.
- Saat data sedang dimuat, tampilkan indikator pemuatan.

**Kriteria penerimaan:** Pada penggunaan pertama, ketiga situs bawaan terlihat.
Setelah daftar dikosongkan, kondisi kosong tetap terlihat setelah aplikasi
dibuka kembali.

### F-02 — Menambahkan favorit

- Sediakan aksi **Tambah favorit**.
- Formulir meminta nama dan URL.
- Nama wajib diisi.
- URL tanpa skema otomatis menggunakan `https://`.
- URL hanya menerima skema HTTP atau HTTPS dan harus memiliki host yang valid.
- Perubahan disimpan sebelum daftar diperbarui.

**Kriteria penerimaan:** Favorit dengan nama dan URL valid muncul di daftar dan
tetap ada setelah aplikasi dimulai ulang. Input tidak valid ditolak dengan
pesan validasi.

### F-03 — Mengedit favorit

- Sediakan aksi edit pada setiap kartu.
- Formulir edit menampilkan nilai nama dan URL saat ini.
- Setelah disimpan, nilai baru menggantikan nilai lama dan tersimpan secara
  lokal.
- Membatalkan formulir tidak mengubah daftar.

**Kriteria penerimaan:** Setelah edit berhasil, kartu menampilkan nilai baru
dan perubahan bertahan setelah aplikasi dimulai ulang.

### F-04 — Menghapus favorit

- Sediakan aksi hapus pada setiap kartu.
- Minta konfirmasi sebelum menghapus.
- Membatalkan konfirmasi mempertahankan favorit.
- Mengonfirmasi penghapusan menyimpan daftar yang telah diperbarui.

**Kriteria penerimaan:** Favorit yang dikonfirmasi untuk dihapus tidak lagi
ditampilkan dan tidak muncul kembali setelah aplikasi dimulai ulang.

### F-05 — Membuka situs

- Mengetuk kartu membuka URL terkait melalui browser atau aplikasi eksternal
  yang menangani tautan.
- Jika tautan tidak dapat dibuka, tampilkan pesan yang menjelaskan kegagalan.

**Kriteria penerimaan:** URL HTTP/HTTPS yang tersimpan diteruskan ke mekanisme
pembuka tautan perangkat.

### F-06 — Menangani kegagalan penyimpanan

- Kegagalan saat memuat atau menyimpan data harus diberitahukan kepada pengguna.
- Jika penyimpanan gagal, jangan tampilkan perubahan sebagai berhasil
  tersimpan.

## 7. Alur pengguna utama

### Membuka situs

1. Pengguna membuka aplikasi.
2. Aplikasi memuat favorit tersimpan atau menampilkan situs bawaan.
3. Pengguna mengetuk kartu situs.
4. Aplikasi meminta sistem membuka URL di browser.

### Menambahkan situs

1. Pengguna mengetuk **Tambah favorit**.
2. Pengguna mengisi nama dan URL.
3. Aplikasi memvalidasi lalu menyimpan data.
4. Kartu baru muncul pada daftar.

### Mengedit atau menghapus situs

1. Pengguna memilih aksi edit atau hapus pada kartu.
2. Untuk edit, pengguna mengubah data dan menyimpan.
3. Untuk hapus, pengguna mengonfirmasi tindakan.
4. Aplikasi menyimpan daftar yang diperbarui.

## 8. Kebutuhan nonfungsional

- **Persistensi:** Simpan data lokal pada perangkat atau browser; tidak
  memerlukan koneksi jaringan untuk melihat daftar tersimpan.
- **Privasi:** MVP tidak mengirim daftar favorit ke layanan backend.
- **Keamanan:** Hanya URL HTTP dan HTTPS yang boleh disimpan melalui formulir.
- **Kompatibilitas:** Sediakan build Android APK dan web.
- **Kualitas:** Kode aplikasi harus lolos `flutter analyze lib`; build rilis
  Android dan web harus berhasil.
- **Bahasa:** Teks antarmuka dan validasi menggunakan bahasa Indonesia.

## 9. Metrik keberhasilan

- Pengguna dapat melihat tiga situs bawaan pada penggunaan pertama.
- Alur tambah, edit, hapus, dan buka situs dapat diselesaikan tanpa kegagalan.
- Perubahan favorit tetap tersedia setelah aplikasi dimulai ulang.
- Build rilis Android dan web berhasil pada CI.

## 10. Asumsi dan risiko

- Aplikasi ditujukan untuk penggunaan personal pada satu perangkat atau browser.
- Membuka situs bergantung pada tersedianya browser atau aplikasi penangan tautan
  pada platform pengguna.
- Data lokal dapat hilang jika data aplikasi atau penyimpanan browser dihapus.
- Label dan URL situs bawaan dapat diubah pengguna melalui fitur edit.

## 11. Referensi implementasi

- Aplikasi: [lib/main.dart](../lib/main.dart)
- Dependensi dan versi: [pubspec.yaml](../pubspec.yaml)
- Build otomatis: [workflow GitHub Actions](../.github/workflows/build.yml)
