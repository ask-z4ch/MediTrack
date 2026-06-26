import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../vitals/providers/vitals_provider.dart';
import '../services/sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final vitalsDao = ref.read(vitalsDaoProvider);
  return SyncService(vitalsDao);
});
