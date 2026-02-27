🧱 STRUKTUR HALAMAN UTAMA (MVP – WAJIB)
1️⃣ Splash / App Init

Tujuan:

Cek login

Load config

Cek subscription (free / premium)

Logic:

Logged in → Home

Guest → Home (limited)

2️⃣ Home / Dashboard

Ini halaman paling sering dibuka

Isi:

🔘 Button Scan Struk

📊 Ringkasan bulan ini:

Total pengeluaran

Jumlah bill

🧾 Recent Bills (list)

🚀 CTA upgrade premium (kalau free)

3️⃣ Scan Struk (Camera Page)

Critical UX

Fitur:

Camera live

Auto crop

Flash on/off

Ambil foto / upload galeri

Flow:
Camera → Preview → OCR

4️⃣ OCR Processing / Loading

Bisa digabung atau page sendiri

Isi:

Loading animation

Status:

“Reading receipt…”

“Parsing items…”

5️⃣ Review & Edit Struk (SUPER PENTING)

Halaman penentu UX lo bagus apa enggak

Isi:

List item (editable):

Nama

Qty

Harga

Pajak

Service charge

Total

Confidence indicator (AI)

Action:

✏️ Edit item

➕ Add item manual

➡️ Next → Split Bill

6️⃣ Split Bill Setup

Mode split:

Rata

By item (WAJIB)

Weighted

Custom

Fitur:

Add participant

Assign item per orang

Fraction (½, ⅓)

Preview total per orang

7️⃣ Split Result / Settlement

Isi:

List participant

Jumlah yg harus dibayar

Ke siapa bayarnya

Status: unpaid / paid

Action:

🔗 Share link

⭐ Upgrade premium CTA (kalau free)

8️⃣ Share Link – Public View (WebView / Flutter Page)

Bisa dibuka tanpa login

Isi:

Nama bill

Total tagihan dia

Instruksi bayar (text)

Status unpaid / paid

Free:

Read-only

Premium:

Mark as paid

Upload bukti

9️⃣ Bill Detail Page

Untuk buka bill lama

Isi:

Info bill

Peserta

Settlement status

Bukti bayar (premium)

Edit (premium)

💰 MONEY TRACKER (WAJIB PHASE 2)
🔟 Expense Dashboard

Isi:

Chart pengeluaran

Filter:

Daily

Weekly

Monthly

Category breakdown

1️⃣1️⃣ Expense List

Isi:

List semua expense

Source:

Dari bill

Manual

Filter & search

1️⃣2️⃣ Add / Edit Expense (Manual)

Isi:

Amount

Category

Date

Note

👥 GROUP FEATURE (PREMIUM GROUP)
1️⃣3️⃣ Group List

Isi:

List group

Button create group

Badge unpaid bill

1️⃣4️⃣ Group Detail

Isi:

Member list

Group bills

Statistik grup

1️⃣5️⃣ Group Bill Flow

Mirip bill personal, tapi:

Auto add member

Default split rule

🔔 NOTIFICATION & REMINDER
1️⃣6️⃣ Reminder Generator

Isi:

Template WA

Copy button

List siapa belum bayar

👤 AUTH & PROFILE
1️⃣7️⃣ Login / Register

Google

Apple

Guest mode

1️⃣8️⃣ Profile

Isi:

User info

Plan status

Usage limit

Button upgrade

1️⃣9️⃣ Subscription / Paywall

Isi:

Compare Free vs Premium

Monthly / Yearly / Lifetime

CTA jelas

⚙️ SETTING & SUPPORT
2️⃣0️⃣ Settings

Isi:

Notification toggle

Language

Export data

Privacy

2️⃣1️⃣ Help / FAQ

Isi:

Cara scan

Cara split

Disclaimer (no payment handling)

🧠 STRUKTUR NAVIGASI (REKOMENDASI)

Bottom Nav (4 tab):

Home

Bills

Expense

Profile

Scan struk = Floating Action Button (FAB)

🔥 TOTAL HALAMAN (REALISTIS)
Phase	Jumlah
MVP	9–10
+ Expense	+3
+ Group	+3
Full	±20–22 halaman