# MediTrack

A personal health tracking and medication management application built for individuals dealing with chronic conditions like diabetes, hypertension, or post-surgery recovery.

## Architecture

- **Local Database:** SQLite via Drift — offline-first, all data stored locally
- **Cloud Sync:** Supabase — data pushed on app resume when connected to WiFi
- **State Management:** Riverpod with code generation
- **Navigation:** GoRouter with ShellRoute for bottom nav tabs

## Sync Strategy

Data is written locally first and pushed to Supabase in the background. The sync service runs on app resume and only uploads over WiFi to conserve mobile data.

**Conflict resolution:** Last-write-wins via upsert. Each record carries a `logged_at` / `calculated_at` / `visit_date` timestamp. If the same record was modified on two devices, the version that was synced last overwrites the server copy. Local writes are always the ground truth — the server is treated as a backup, not an authoritative store.

### Known Bugs / Limitations

- **Last-write-wins:** If the same record is edited on two devices before either has synced, the last one to sync overwrites the other's changes silently. No merge or diff is attempted.
- **No offline queue UI:** Failed syncs are logged via `debugPrint` but not surfaced to the user. There is no retry queue or manual "Sync Now" button.
- **WiFi-only sync:** Sync is skipped on mobile data. If the user never connects to WiFi, data stays local indefinitely.
- **Supabase bucket setup:** The `prescriptions` Storage bucket must be created manually in the Supabase dashboard and set to private (authenticated access only).
- **Auth required:** All features require a signed-in Supabase user. Sign-out clears the session but local data persists in SQLite.

## Build

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## Project Setup (changelog)

1. feat: init flutter project for meditrack
2. feat: add core dependencies - drift, riverpod, flutter_unity_widget, fl_chart
3. feat: basic folder structure - screens models services widgets providers
4. feat: android manifest - camera storage notification location permissions
5. feat: placeholder home screen and bottom nav skeleton
6. chore: app icon and colour scheme assets added
7. chore: drift database class - empty schema stub
