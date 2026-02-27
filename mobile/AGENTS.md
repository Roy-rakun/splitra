# Mobile App (Flutter)

## Package Identity
- **Apa ini**: Aplikasi utama yang dipakai oleh user akhir untuk memindai struk, mengatur patungan (split bill), dan membagikan porsinya ke partisipan lain.
- **Tech Stack**: Flutter, Riverpod / BLoC, On-Device ML Kit (Text Recognition).

## Setup & Run
- **Install deps**: `flutter pub get`
- **Run dev**: `flutter run`
- **Build APK (contoh)**: `flutter build apk`
- **Test**: `flutter test`

## Patterns & Conventions
- Sesuai dengan aturan Root, gunakan Bahasa Indonesia untuk dokumentasi, komentar kode, penamaan yang relevan, serta teks pada UI.
- Manajemen State disarankan menggunakan Riverpod atau Bloc (konsisten).
- Tangani Kamera dan ML Kit dalam Service layer, bukan di UI.
  - ✅ **DO**: Pisahkan logic parsing teks dari ML Kit di `lib/services/ocr_scanner_service.dart`.
  - ❌ **DON'T**: Melakukan inisiasi kamera dan OCR langsung panjang lebar di `lib/views/home_view.dart`.

## Touch Points / Key Files
- Entry: `lib/main.dart`
- Tampilan Utama: `lib/views/` atau `lib/screens/`
- State Control: `lib/providers/`
- Manajemen API: `lib/services/api_client.dart`

## JIT Index Hints
- Mencari widget: `rg -n "class .* extends (Stateless|Stateful)Widget" lib/`
- Mencar API call: `rg -n "http" lib/services/`

## Pre-PR Checks
```bash
flutter analyze && flutter test
```

## Animasi dan UI
- Gunakan motion.dev untuk animasi dan pergerakan UI
- Gunakan library flutter UI yang terbaik agar hasilnya profesional dan modern.
- saat membuat UI pastikan responsif dan dapat berjalan di berbagai ukuran layar.
- saat melihat hasil struk yang di split dan hasil share ke participant, desainnya harus seperti struk asli.
