# Favorit Web

Aplikasi Flutter untuk menyimpan dan membuka situs web favorit.

## Fitur

- Tiga situs tersedia secara default:
  - [ninofelino12.github.io](https://ninofelino12.github.io)
  - [ninofelino.github.io](https://ninofelino.github.io)
  - [hub.docker.com](https://hub.docker.com)
- Tambah favorit dengan nama dan URL, atau edit dan hapus favorit yang ada.
- Data favorit disimpan secara lokal di perangkat.
- URL yang dibagikan dari aplikasi lain dapat disimpan ke daftar favorit
  melalui menu **Bagikan** Android.
- Ketuk kartu situs untuk membukanya di browser.
- URL tanpa skema akan otomatis menggunakan `https://`.

## Menjalankan aplikasi

Pasang [Flutter SDK](https://docs.flutter.dev/get-started/install), buka terminal
di direktori proyek, lalu jalankan:

```sh
# Membuat berkas platform yang dibutuhkan (cukup sekali)
flutter create --platforms=android,ios,web .

# Mengambil dependensi dan menjalankan aplikasi
flutter pub get
flutter run
```

Pilih perangkat atau emulator yang tersedia saat menjalankan `flutter run`.

## Build lokal

```sh
flutter build apk --release
flutter build web --release
```

APK tersedia di `build/app/outputs/flutter-apk/app-release.apk`, sedangkan
berkas web tersedia di `build/web/`.

## Build otomatis

Workflow [Build Flutter app](.github/workflows/build.yml) berjalan saat ada push
atau pull request ke repositori, dan juga bisa dijalankan secara manual dari tab
**Actions** di GitHub. Workflow menjalankan `flutter analyze`, membuat build
Android APK dan web, lalu mengunggah keduanya sebagai artifact bernama
`flutter-builds`. Lihat [panduan mengunduh artifact](docs/download-artifact.md)
untuk langkah mengunduh dan menggunakan hasil build.
