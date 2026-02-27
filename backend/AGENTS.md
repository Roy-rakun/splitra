# Backend API (Laravel)

## Package Identity
- **Apa ini**: Core API dan Back-office aplikasi Split Bill. Bertugas menyimpan data user, bill, participant, integrasi AI parsing eksternal (fallback), serta *sharing mechanics*.
- **Tech Stack**: PHP 8.3, Laravel 11, PostgreSQL / MySQL, Sanctum.

## Setup & Run
- **Install deps**: `composer install`
- **Env**: `cp .env.example .env && php artisan key:generate`
- **Run dev server**: `php artisan serve`
- **Queue worker**: `php artisan queue:work`
- **Test**: `php artisan test`

## Patterns & Conventions
**[ATURAN SANGAT PENTING TERKAIT DATABASE]**
- ❌ **JANGAN PERNAH** melakukan `php artisan migrate:fresh` atau `php artisan migrate:fresh --seeder`.
- ✅ **SELALU** lakukan migrasi sesuai dengan nama file yang dituju dan spesifik. Contoh: `php artisan migrate --path=/database/migrations/xxxx_xx_xx_xxxxxx_create_bills_table.php`

**Pola Kode Lainnya:**
- Bahasa dalam dokumentasi/respons chat Wajib Bahasa Indonesia. Untuk struktur standar framework (nama model, controller) gunakan bahasa Inggris (`Bill`, `Participant`), namun komentar kode pakai Bahasa Indonesia.
- ✅ **DO**: Letakkan logika kalkulasi dan split bill di `app/Services/BillService.php`.
- ❌ **DON'T**: Menyimpan fungsi kalkulasi tebal di Controller.
- Implementasi `unique_code` (tipe short string misal 8 karakter alphanumeric acak) di tabel `bill_participants`.

## Touch Points / Key Files
- Rute API: `routes/api.php`
- Model Data: `app/Models/` (Khususnya `Bill`, `BillItem`, `BillParticipant`)
- Logika Inti: `app/Services/`
- Validasi: `app/Http/Requests/`

## JIT Index Hints
- Temukan Route: `rg -n "Route::" routes/api.php`
- Temukan Logika di Service: `rg -n "class .*Service" app/Services/`

## Pre-PR Checks
```bash
php artisan test && php artisan route:list
```
