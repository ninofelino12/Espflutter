# Favorit Web

Aplikasi Flutter sederhana untuk menyimpan dan membuka situs web favorit.

## Fitur

- Menampilkan tiga situs awal: `ninofelino12.github.io`, `ninofelino.github.io`, dan `hub.docker.com`.
- Menambah, mengedit, dan menghapus favorit.
- Menyimpan perubahan secara lokal di perangkat.
- Membuka situs di browser saat kartu favorit diketuk.

## Menjalankan aplikasi

Pastikan Flutter SDK sudah terpasang, lalu jalankan:

```sh
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
```

## GitHub Actions

Workflow `.github/workflows/build.yml` menjalankan analisis Flutter dan membuat
build Android APK serta web pada setiap push atau pull request. Hasil build
tersedia sebagai artifact pada halaman workflow GitHub Actions.