import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../vitals/daos/vitals_dao.dart';

class SyncService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final VitalsDao _vitalsDao;

  SyncService(this._vitalsDao);

  Future<String?> uploadPrescription(String localPath, String userId) async {
    final file = File(localPath);
    if (!await file.exists()) return null;

    final filename = p.basename(localPath);
    final storagePath = '$userId/$filename';

    try {
      await _supabase.storage
          .from('prescriptions')
          .upload(storagePath, file,
              fileOptions: const FileOptions(upsert: true));
      return storagePath;
    } catch (e) {
      debugPrint('Prescription upload failed: $e');
      return null;
    }
  }

  Future<void> syncAll() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none) ||
        connectivity.contains(ConnectivityResult.mobile)) {
      return;
    }
    await _syncVitals();
  }

  Future<void> _syncVitals() async {
    final unsynced = await _vitalsDao.getUnsynced();
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || unsynced.isEmpty) return;

    for (final entry in unsynced) {
      try {
        await _supabase.from('vitals_entries').upsert({
          'id': entry.id.toString(),
          'user_id': userId,
          'logged_at': entry.loggedAt.toIso8601String(),
          'bp_systolic': entry.bpSystolic,
          'bp_diastolic': entry.bpDiastolic,
          'blood_sugar_fasting': entry.bloodSugarFasting,
          'blood_sugar_post_meal': entry.bloodSugarPostMeal,
          'temperature_celsius': entry.temperatureCelsius,
          'weight_kg': entry.weightKg,
          'spo2_percent': entry.spo2Percent,
          'notes': entry.notes,
        });
        await _vitalsDao.markAsSynced(entry.id);
      } catch (e) {
        debugPrint('Sync failed for vitals entry ${entry.id}: $e');
      }
    }
  }
}
