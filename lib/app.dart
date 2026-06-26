import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/companion/providers/chs_provider.dart';
import 'features/medicines/daos/medicine_dose_dao.dart';
import 'features/medicines/daos/medicine_dao.dart';
import 'features/medicines/providers/medicine_provider.dart';

class MediTrackApp extends ConsumerStatefulWidget {
  const MediTrackApp({super.key});

  @override
  ConsumerState<MediTrackApp> createState() => _MediTrackAppState();
}

class _MediTrackAppState extends ConsumerState<MediTrackApp> {
  AppLifecycleListener? _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () {
        ref.read(cHSNotifierProvider.notifier).recalculate();
      },
    );
  }

  @override
  void dispose() {
    _listener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NotificationService.setContext(context);
    NotificationService.setActionHandler((medicineId, actionId) async {
      final doseDao = ref.read(medicineDoseDaoProvider);
      final medDao = ref.read(medicineDaoProvider);

      final medicine = await medDao.getMedicine(medicineId);
      if (medicine == null) return;

      final doses = await doseDao.getTodaysDoses();
      final dose = doses.where((d) => d.medicineId == medicineId && d.status == 'pending').firstOrNull;
      if (dose == null) return;

      if (actionId == 'taken') {
        await doseDao.markTaken(dose.id);
      } else if (actionId == 'skip') {
        await doseDao.markSkipped(dose.id);
      }
    });
    NotificationService.setSnoozeHandler((medicineId, originalNotificationId, duration) async {
      final medDao = ref.read(medicineDaoProvider);
      final medicine = await medDao.getMedicine(medicineId);
      if (medicine == null) return;

      await NotificationService.scheduleSnooze(
        notificationId: originalNotificationId,
        medicineName: medicine.name,
        duration: duration,
      );
    });

    return MaterialApp.router(
      title: 'MediTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
