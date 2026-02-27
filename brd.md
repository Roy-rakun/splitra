# BUSINESS REQUIREMENT DOCUMENT (BRD)

## Aplikasi Split Bill & Expense Tracker Berbasis AI

---

## 1. Latar Belakang

Aplikasi ini dibuat untuk menyelesaikan masalah umum di masyarakat Indonesia terkait pembagian tagihan (split bill) dan pencatatan pengeluaran. Masalah utama yang dihadapi pengguna adalah:

* Ribet membagi bill manual
* Salah hitung pajak & service charge
* Sungkan / capek nagih teman
* Tidak ada pencatatan pengeluaran yang rapi

Solusi yang ditawarkan adalah aplikasi **AI-powered split bill & expense tracker** yang:

* Bisa scan struk
* Auto membaca & memproses data
* Membagi tagihan secara cerdas
* Melacak status pembayaran
* Tidak menyimpan atau memproses uang (non-fintech)

---

## 2. Tujuan Produk

* Menyederhanakan proses split bill
* Menghindari konflik sosial karena nagih uang
* Memberikan insight pengeluaran pribadi & grup
* Menjadi aplikasi daily-use (sticky)
* Monetisasi melalui subscription (bukan payment handling)

---

## 3. Target Pengguna

### 3.1 Individual

* Nongkrong / bukber / makan ramean
* Anak kos
* Freelancer

### 3.2 Group / Komunitas

* Tim kantor kecil
* Circle nongkrong tetap
* Komunitas hobi

### 3.3 B2B (Future)

* Cafe / resto
* Co-working space
* Event organizer

---

## 4. Scope Aplikasi

### In Scope

* Scan & parsing struk
* Split bill otomatis & manual
* Status pembayaran (paid/unpaid)
* Expense tracking
* Group management
* Analytics dasar

### Out of Scope

* Menyimpan saldo
* Transfer uang
* Withdraw
* Escrow

---

## 5. Klasifikasi Fitur Berdasarkan Plan

## 5.1 FREE PLAN

### Fitur:

* Scan struk (limit 3–5/bulan)
* OCR on-device
* Auto split bill (rata / by item)
* Tambah peserta
* Share link split bill (read-only)
* Manual add item
* Kategori expense otomatis

### Batasan:

* Tidak bisa update status paid
* Tidak bisa upload bukti bayar
* History terbatas
* Tidak ada reminder
* Tidak ada group

---

## 5.2 PREMIUM PERSONAL

### Semua fitur FREE +

#### Split Bill Advanced

* Update status paid / unpaid
* Edit settlement setelah share
* Upload bukti pembayaran
* Partial payment (future-ready)

#### Reminder & Tracking

* Reminder manual via WhatsApp
* Notifikasi status

#### Expense Tracker

* History pengeluaran unlimited
* Chart bulanan
* Budget limit
* Insight AI sederhana

#### Lainnya

* Cloud backup
* Export CSV / PDF

---

## 5.3 PREMIUM GROUP (ADD-ON)

### Group Management

* Buat group
* Member tetap
* Role (Owner, Admin, Member)

### Group Bill

* Auto add member
* Default split rule
* Exclude member
* Group history

### Settlement Group

* Tracking siapa belum bayar
* Statistik keterlambatan
* Reminder massal

### Group Analytics

* Total pengeluaran grup
* Rata-rata bill
* Top spender

### Pricing Model

* Add-on per group
* Limit member (configurable)

---

## 6. Fitur Utama (Detail Teknis)

### 6.1 Scan & OCR

* Capture image
* Auto crop
* OCR on-device
* Fallback ke backend

### 6.2 AI Parsing

* Parsing item
* Quantity
* Tax & service charge
* Subtotal & total
* Confidence score

### 6.3 Split Engine

* Rata
* By item
* Weighted
* Manual override

### 6.4 Share Link

* Public access
* No login required
* Read-only (free)
* Interactive (premium)

---

## 7. Expense Tracker

### Kategori

* Food & Drink
* Transport
* Rent
* Entertainment
* Shopping
* Custom

### Insight

* Spending trend
* Category dominance
* Overbudget alert

---

## 8. Notifikasi

* Push notification
* Manual reminder trigger
* WhatsApp text generator

---

## 9. Security & Compliance

* Tidak menyimpan uang
* Tidak memproses transaksi
* Data terenkripsi
* Role-based access
* GDPR-ready

---

## 10. Tech Stack

### Mobile

* Flutter
* Riverpod / Bloc
* ML Kit OCR

### Backend

* Laravel 11
* PHP 8.3
* REST API
* Laravel Sanctum

### Database

* PostgreSQL / MySQL
* Redis (queue & cache)

### AI Layer

* On-device OCR
* LLM API (OpenAI / Gemini / Claude)

### Infra

* Docker
* Nginx
* VPS / Cloud
* Object Storage (S3-compatible)

---

## 11. Non-Functional Requirement

* Response < 2 detik
* Uptime 99%
* Scalable
* Maintainable

---

## 12. Monetisasi

### Personal

* Monthly
* Yearly
* Lifetime (limited)

### Group

* Per group / month

### Future

* White Label


Ringkas isi pricing di PDF (biar kebayang cepat):

FREE

Rp0

Scan terbatas

Share link (read-only)

PREMIUM PERSONAL

Rp15.000 / bulan

Rp120.000 / tahun

Rp199.000 lifetime (limited)

Bisa update paid/unpaid, bukti bayar, reminder, expense tracker penuh

PREMIUM GROUP (ADD-ON)

Rp25.000 / grup / bulan

10–15 member

Analytics & reminder grup

---

## 13. Risiko & Mitigasi

| Risiko                   | Mitigasi                 |
| ------------------------ | ------------------------ |
| OCR gagal                | Manual edit              |
| AI parsing salah         | Confidence + review      |
| User salah paham payment | Copywriting & disclaimer |

---

## 14. KPI & Success Metrics

* Conversion Free → Premium
* Retention 30 hari
* Jumlah bill / user
* MAU

---

## 15. Roadmap Tingkat Tinggi

Phase 1: MVP Personal
Phase 2: Expense Tracker
Phase 3: Premium Group
Phase 4: White Label

---

## 16. Penutup

Dokumen ini menjadi acuan utama pengembangan produk agar fitur, scope, dan monetisasi tetap konsisten serta scalable.

---

**END OF BRD**
