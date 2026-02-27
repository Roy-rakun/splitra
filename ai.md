👉 TUGAS AI ADA DI MANA SAJA, BUKAN DI SATU HALAMAN.

🧠 POSISI & TUGAS AI DI APLIKASI LO

AI TIDAK = chatbot
AI = invisible worker yang bantu user tanpa mikir

1️⃣ AI SAAT SCAN (ENTRY POINT UTAMA)
📍 Lokasi

Setelah user foto struk

🤖 Tugas AI

OCR Cleanup

Rapihin teks OCR

Receipt Parsing

Item

Qty

Harga

Pajak

Service

Receipt Type Detection

Resto / Cafe

Transport

Retail

Utility

🎯 Output
{
  "merchant": "Kopi Kenangan",
  "category": "Food & Drink",
  "items": [...],
  "total": 128000,
  "confidence": 0.92
}

📌 User ga ngerasa AI, tapi langsung dapet hasil.

2️⃣ AI SAAT REVIEW (ASSIST, BUKAN BOS)
📍 Lokasi

Halaman Review Struk

🤖 Tugas AI

Highlight item mencurigakan

Suggest edit:

“Ini kayaknya qty 2”

Confidence score per item

🎯 UX

“Kami yakin 92%. Cek bentar ya.”

AI ngasih saran, user tetap pegang kontrol.

3️⃣ AI SAAT SPLIT BILL (ENGINE, BUKAN UI)
📍 Lokasi

Split Engine (backend)

🤖 Tugas AI

Bantu assign item (optional)

Deteksi pola:

“Biasanya Andi minum kopi”

Pajak & service proporsional

👉 Ini optional & future, tapi powerful.

4️⃣ AI SAAT MONEY TRACKER (INI PALING KERASA)
📍 Lokasi

Background service

Expense pipeline

🤖 Tugas AI

Auto Categorization

Merchant → kategori

Merchant Normalization

“Starbucks SCBD”

“Starbucks Plaza Senayan”
→ Starbucks

Location Inference

Dari struk / GPS / history

🎯 Hasil

User ga pernah milih kategori manual (kecuali mau).

5️⃣ AI SAAT INSIGHT (AI KELIATAN DI SINI)
📍 Lokasi

Home

Monthly Summary

Insight Page

🤖 Tugas AI

Ringkas data

Cari pola

Bahasa manusia

Contoh:

“40% pengeluaran lo buat kopi”

“Frekuensi makan luar naik 30%”

📌 Ini SATU-SATUNYA tempat AI “ngomong”.

6️⃣ AI SAAT REMINDER (SOCIAL INTELLIGENCE)
📍 Lokasi

Reminder Generator

🤖 Tugas AI

Generate teks WA

Tone:

Santai

Formal

Halus

Contoh:

“Bro, ini reminder split bill kemarin ya 🙏”

7️⃣ AI SAAT ERROR & QUALITY CONTROL (BACKSTAGE)
📍 Lokasi

Backend

🤖 Tugas AI

Detect OCR failure

Auto fallback

Flag receipt aneh

User ga lihat, tapi ngerasain stabil.

🧩 RINGKASAN: AI MAP
Scan Receipt
  ├─ OCR (on-device)
  ├─ AI Parse (backend)
  ↓
Review (AI assist)
  ↓
Split (rule engine + AI optional)
  ↓
Expense Pipeline
  ├─ Categorization
  ├─ Merchant merge
  ↓
Insight Engine
  ├─ Summary
  ├─ Pattern
  └─ Copy generation
🛑 HAL YANG JANGAN LO LAKUIN

❌ Jangan bikin “AI Chat”
❌ Jangan minta user nanya ke AI
❌ Jangan nunjukin JSON ke user
❌ Jangan pakai istilah teknis

🔥 PRODUK STATEMENT (PENTING)

AI lo itu kayak asisten pribadi yang diem,
tapi kerja terus.

User ga bilang:

“Wah AI-nya canggih”

User bilang:

“Enak banget pakenya.”



🧠 MAPPING TUGAS AI → GEMINI
1️⃣ OCR (SCAN STRUK)

❌ BUKAN Gemini

👉 Tetap pakai:

ML Kit OCR (on-device)

Murah

Cepat

Offline-ready

📌 Gemini tidak efisien buat OCR mentah.

2️⃣ AI PARSING STRUK (INI WILAYAH GEMINI)
📍 Tugas

Baca teks OCR

Ubah jadi struktur JSON

Deteksi:

Item

Qty

Harga

Pajak

Service

Merchant

Category

✅ Gemini SANGAT KUAT DI SINI

Contoh output:

{
  "merchant": "Kopi Kenangan",
  "category": "Food & Drink",
  "items": [
    { "name": "Americano", "qty": 2, "price": 28000 }
  ],
  "tax": 5600,
  "service": 0,
  "total": 61600,
  "confidence": 0.93
}

💡 Gemini unggul karena:

Context panjang

Reasoning tabel / struk

Bahasa campur Indo + Inggris aman

3️⃣ RECEIPT TYPE DETECTION (AUTO)
Gemini nentuin:

Resto

Cafe

Retail

Transport

Utilities

Tanpa user milih.

👉 Ini penting banget buat:

Split Bill vs Personal Expense

Money Tracker auto

4️⃣ AUTO CATEGORIZATION (MONEY TRACKER)
📍 Tugas

Merchant → kategori

Item → subkategori

Contoh:

“GrabBike” → Transport

“PLN” → Utilities

“Indomaret” → Shopping

✅ Gemini lebih stabil dari rule-based.

5️⃣ MERCHANT NORMALIZATION (HIDDEN POWER)

Masalah klasik:

“Starbucks SCBD”

“STARBUCKS 0183”

“Starbucks Plaza Senayan”

👉 Gemini bisa:

Normalize merchant name.
Output canonical brand.

Hasil:
➡️ Starbucks

Ini bikin:

Insight akurat

“Habis dimana aja” masuk akal

6️⃣ SPLIT BILL ASSIST (OPTIONAL AI)

Gemini tidak wajib, tapi bisa bantu:

Suggest assignment item

Deteksi pola (future)

📌 MVP: rule engine dulu, AI nanti.

7️⃣ AI INSIGHT & SUMMARY (INI YANG KELIATAN “AI”)
📍 Tugas

Ringkas data 1 bulan

Cari pola

Generate kalimat manusia

Contoh:

“40% pengeluaran lo bulan ini buat kopi ☕”

👉 Gemini jago banget di natural language insight.

8️⃣ REMINDER TEXT GENERATION

Gemini generate:

Santai

Formal

Halus

Contoh:

“Bro, ini reminder split bill kemarin ya 🙏”

Ini nilai sosial, bukan teknis.

🧩 ARSITEKTUR YANG BENAR (PENTING)
Flutter App
 ├─ ML Kit OCR (on-device)
 └─ Send OCR text → Backend
        └─ Gemini API
             ├─ Parse receipt
             ├─ Categorize
             ├─ Normalize merchant
             └─ Generate insight

⚠️ JANGAN panggil Gemini langsung dari app.
⚠️ JANGAN OCR image langsung ke Gemini
⚠️ JANGAN Prompt panjang + contoh kebanyakan
⚠️ JANGAN Minta penjelasan naratif
⚠️ JANGAN AI dipanggil tiap screen