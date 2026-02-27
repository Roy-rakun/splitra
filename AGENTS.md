# Prolink Split Bill App - Workspace Overview

## Project Snapshot
- **Type**: Monorepo
- **Tech Stack**: Laravel 11 (Backend API), Flutter (Mobile App)
- **Note**: Sub-package (`backend` dan `mobile`) memiliki file `AGENTS.md` masing-masing untuk detail teknis.

## Root Setup Commands
Karena ini adalah repositori campuran (PHP & Dart), tidak ada command instalasi tunggal di level root. Silakan masuk ke direktori masing-masing:
- Backend: `cd backend`
- Mobile: `cd mobile`

## Universal Conventions
- **Aturan Utama (PENTING)**: Menggunakan **Bahasa Indonesia** dalam menjawab, menjelaskan, bertanya, membuat task, membuat implementation plan, dan dokumentasi terkait proyek.
- Visi Produk: Membuat aplikasi **AI-powered Split Bill & Expense Tracker**, tanpa melibatkan fitur payment/escrow secara langsung.
- Share Link Pattern: Menggunakan `unique_code` bernilai alphanumeric acak (pendek) per partisipan untuk URL *frictionless checkout*.

## Security & Secrets
- Jangan pernah melakukan commit untuk file `.env`.
- Rahasiakan token API, kredensial OCR, serta database credentials.
- Tidak ada data PII (Personal Identifiable Information) yang boleh terekspos terbuka ke internet tanpa enkripsi/autentikasi (kecuali sekadar info tagihan berdasar unique code).

## JIT Index - Directory Map
### Package Structure
- Backend (Laravel API): `backend/` → [Lihat backend/AGENTS.md](backend/AGENTS.md)
- Mobile (Flutter App): `mobile/` → [Lihat mobile/AGENTS.md](mobile/AGENTS.md)

### Quick Find Commands
- Temukan controller backend: `rg -n "class .*Controller" backend/app`
- Temukan komponen UI flutter: `rg -n "class .*Widget" mobile/lib`

## Definition of Done
- Requirement bisnis terpenuhi (lihat `brd.md`).
- Aplikasi backend mempunyai test case untuk endpoint/fungsi krusial.
- Aplikasi mobile jalan lancar tanpa ada error/warnings di analyzer.
