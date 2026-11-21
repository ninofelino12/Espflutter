# Mengunduh hasil build

Workflow [Build Flutter app](../.github/workflows/build.yml) membuat artifact
bernama `flutter-builds` yang berisi APK Android dan berkas build web. Workflow
berjalan otomatis saat ada push atau pull request, dan dapat dijalankan manual.

## Melalui GitHub

1. Buka repositori di GitHub, lalu pilih tab **Actions**.
2. Pilih workflow **Build Flutter app** dan buka run yang berstatus **Success**.
3. Pada bagian **Artifacts** di halaman run, klik `flutter-builds`.
4. Unduh lalu ekstrak ZIP tersebut.

Isi ZIP:

- `app/outputs/flutter-apk/app-release.apk` — APK Android untuk diunduh dan
  dipasang pada perangkat.
- `web/` — berkas situs web statis. Unggah isi folder ini ke hosting web statis.

Setelah ZIP diekstrak, buka folder `app/outputs/flutter-apk/` dan salin
`app-release.apk` ke perangkat Android. Buka APK dari perangkat untuk memulai
pemasangan. Jika diminta, izinkan pemasangan aplikasi dari sumber tersebut.

Untuk menjalankan versi web, sajikan berkasnya melalui web server atau hosting;
jangan hanya membuka `index.html` sebagai berkas lokal.

## Melalui GitHub CLI

Pastikan GitHub CLI sudah terpasang dan terautentikasi (`gh auth login`). Cari
run terbaru, lalu unduh artifact menggunakan ID run:

```sh
gh run list --workflow build.yml --limit 5
gh run download <run-id> --name flutter-builds --dir ./downloads
```

Ganti `<run-id>` dengan ID dari perintah pertama. Hasil unduhan akan berada di
`./downloads/app/outputs/flutter-apk/app-release.apk`.

Artifact hanya tersedia untuk run yang berhasil dan akan kedaluwarsa sesuai
kebijakan retensi artifact GitHub Actions pada repositori. APK ini merupakan
hasil build untuk pengujian; pastikan konfigurasi penandatanganan rilis sudah
sesuai sebelum mendistribusikannya secara luas.
