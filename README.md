# MediTrack

## The Problem
Patients managing chronic conditions like diabetes and hypertension forget medicines,
skip vital logs, and arrive at doctor consultations with no organised health record.
They leave without the data their doctor actually needed.

## Our Solution
MediTrack is an offline-first health companion. It logs vitals, tracks medicines,
and stores prescriptions — then generates a clean PDF summary for doctor visits.
At its core is VITA: a 3D companion whose physical state directly reflects the
user's real health data, creating genuine engagement through biological nurturing
instincts rather than hollow gamification.

## Tech Stack
| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| 3D Companion | Unity 2022 LTS via flutter_unity_widget |
| Local Database | Drift (SQLite) |
| State | Riverpod |
| Charts | fl_chart |
| Backend/Sync | Supabase (PostgreSQL + Storage) |
| Notifications | flutter_local_notifications |
| PDF | pdf + printing |

## Download APK
[Download MediTrack v1.0.apk](https://drive.google.com/drive/folders/1Yf5-1nCXRNXiY9Ol_kyhR4PlLDCzg9Zc?usp=drive_link)

## Test Account
Email: `test@meditrack.app` | Password: `Demo@1234`

## Features
- [x] User profile with blood group, conditions, allergies
- [x] Daily vitals logger — BP, blood sugar, temperature, weight, SpO2
- [x] Real-time colour-coded inputs (normal / borderline / critical)
- [x] Medicine reminders with exact alarm scheduling
- [x] Dose tracking — taken / skipped per scheduled dose
- [x] Symptom diary with severity rating
- [x] Weekly and monthly trend charts for all vitals
- [x] Doctor visit log with prescription photo/PDF storage
- [x] One-tap PDF health report for any date range
- [x] Emergency SOS with location to saved contact
- [x] 3D VITA companion — health state driven by Companion Health Score
- [x] Offline-first SQLite, optional Supabase sync on WiFi
- [x] Dark and light theme

## How to Run Locally
```bash
git clone https://github.com/ask-z4ch/MediTrack
cd meditrack
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=yyy
```

## Known Bugs & Limitations
- Supabase sync requires WiFi — mobile data sync intentionally disabled
- PDF export with 90+ day range takes ~3–4 seconds on low-end devices
- Blood sugar mmol/L conversion uses the standard 18.0 divisor (may have minor rounding)
