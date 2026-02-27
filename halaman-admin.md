🧠 DASHBOARD LOGIN (ADMIN / OWNER)
1️⃣ Login Page (Dashboard Auth)

Tujuan

Akses internal (bukan user app)

Role-based (Admin / Ops / Support)

Field

Email

Password

(Optional) 2FA OTP

Action

Login

Forgot Password

Security

Rate limit

CAPTCHA

IP whitelist (optional)

2️⃣ Dashboard Overview (Home)

Ringkasan (Cards)

Total users

Active users (30 hari)

Total bills

Total scan struk

AI cost hari ini / bulan ini

Conversion Free → Premium

Chart

Scan per hari

Revenue (subscription)

OCR fail rate

3️⃣ User Management
3.1 User List

Kolom

User ID

Email

Plan (Free / Premium / Group)

Status (Active / Suspended)

Total scan bulan ini

Join date

Action

View detail

Suspend / activate

Reset limit scan

Force logout

3.2 User Detail

Tab:

Profile

Subscription

Usage

Activity Log

Detail

Device info

Login history

Last activity

Linked providers (Google/Apple)

4️⃣ Subscription & Billing (NON Payment)

Dashboard tidak handle payment, hanya status & sync gateway

Halaman

Subscription list

Active / expired

Lifetime user

Action

Extend subscription

Downgrade / upgrade

Refund flag (manual)

5️⃣ Bill & Receipt Management
5.1 Bills List

Kolom

Bill ID

Owner

Total amount

Participants

Status (open / settled)

Created date

5.2 Bill Detail

Isi

Receipt image

OCR raw text

AI parsed result (JSON view)

Confidence score

Settlement list

Action

Re-parse with AI

Edit manual (ops only)

Flag error

6️⃣ OCR & AI Monitoring (SUPER PENTING)
6.1 OCR Logs

Isi

Image preview

OCR duration

Result length

Error code

6.2 AI Parsing Logs

Isi

Prompt used

Token usage

Cost per request

Output JSON

Fail / success

Action

Retry

Change prompt version

7️⃣ Expense Analytics (Global)

Chart

Avg expense per user

Category distribution

Top merchants (anonymized)

Insight

High spend pattern

Anomaly detection

8️⃣ Group Management
8.1 Group List

Kolom

Group name

Owner

Member count

Active bills

Plan status

8.2 Group Detail

Isi

Members

Bills

Settlement stats

Reminder history

9️⃣ Notification & Template Manager
9.1 WhatsApp Template

Field

Template name

Message body

Variable support

9.2 Push Notification

Title

Body

Target (all / segment)

🔐 SETTINGS (SYSTEM CONFIG)
🔟 System Settings
General

App name

Branding

Maintenance mode

Limits

Free scan limit

Max image size

Max participant

Feature Toggle

AI Insight

Group feature

Export

1️⃣1️⃣ AI Configuration

Field

OCR mode (on-device / backend)

LLM provider

Model name

Max tokens

Prompt version

Action

Test prompt

Rollback

1️⃣2️⃣ Pricing & Plan Config

Harga plan

Feature mapping

Promo flag

Trial config

1️⃣3️⃣ Security & Access Control

Role management

Permission matrix

API key rotation

Webhook secret

1️⃣4️⃣ Audit Log

Isi

Admin action

Timestamp

IP

Affected data

1️⃣5️⃣ Support & Ticket

User issue

OCR error report

Refund request

🧭 NAVIGASI DASHBOARD (Sidebar) - Splitra Dashboard

Overview

Users

Bills

OCR & AI

Groups

Analytics

Subscription

Notification

Settings

Audit Log

🔢 TOTAL HALAMAN DASHBOARD
Modul	Halaman
Auth	1
Core	6
AI & OCR	4
Group	3
Settings	6
Support	2
TOTAL	22–25 halaman