import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/companion/providers/chs_provider.dart';
import 'features/medicines/daos/medicine_dose_dao.dart';
import 'features/medicines/daos/medicine_dao.dart';
import 'features/medicines/providers/medicine_provider.dart';
import 'settings/providers/settings_provider.dart';
import 'features/sync/providers/sync_provider.dart';

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
        ref.read(syncServiceProvider).syncAll();
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
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.cardSurface,
          onSurface: AppColors.textPrimary,
        ),
        cardColor: AppColors.cardSurface,
        cardTheme: CardThemeData(
          color: AppColors.cardSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          bodyMedium: GoogleFonts.nunito(
            color: AppColors.textSecondary,
          ),
        ),
      ),
      themeMode: switch (settings?.theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.dark,
      },
      routerConfig: appRouter,
    );
  }
}
