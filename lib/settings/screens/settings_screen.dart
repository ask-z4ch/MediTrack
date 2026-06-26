import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/services/notification_service.dart';
import '../../features/companion/providers/chs_provider.dart';
import '../../features/doctor_visits/providers/doctor_visit_provider.dart';
import '../../features/medicines/providers/medicine_provider.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../features/symptoms/providers/symptom_provider.dart';
import '../../features/sync/providers/sync_provider.dart';
import '../../features/vitals/providers/vitals_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _medicinesEnabled = true;
  bool _followUpsEnabled = true;
  String _bloodSugarUnit = 'mg/dL';
  String _lastSynced = '';
  bool _syncing = false;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _medicinesEnabled = prefs.getBool('notif_medicines') ?? true;
      _followUpsEnabled = prefs.getBool('notif_followups') ?? true;
      _bloodSugarUnit = prefs.getString('blood_sugar_unit') ?? 'mg/dL';
    });
    _loadSyncTimestamp();
  }

  Future<void> _loadSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('last_sync_at');
    if (stored == null) {
      setState(() => _lastSynced = 'Not synced yet');
      return;
    }
    final dt = DateTime.tryParse(stored);
    if (dt == null) {
      setState(() => _lastSynced = 'Not synced yet');
      return;
    }
    setState(() => _lastSynced = _relativeTime(dt));
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }

  Future<void> _toggleNotif(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      if (key == 'notif_medicines') _medicinesEnabled = value;
      if (key == 'notif_followups') _followUpsEnabled = value;
    });
  }

  Future<void> _setBloodSugarUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('blood_sugar_unit', unit);
    setState(() => _bloodSugarUnit = unit);
  }

  Future<void> _syncNow() async {
    setState(() => _syncing = true);
    await ref.read(syncServiceProvider).syncAll();
    await _loadSyncTimestamp();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync complete')),
    );
  }

  Future<void> _exportJson() async {
    setState(() => _exporting = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final profile = await db.profileDao.getProfile();
      final vitals = await db.vitalsDao.getVitalsInRange(
        DateTime(2000),
        DateTime(2100),
      );
      final medicines = await db.medicineDao.getAllMedicines();
      final symptoms = await db.symptomDao.getSymptomsInRange(
        DateTime(2000),
        DateTime(2100),
      );
      final visits = await db.doctorVisitDao.getAllVisits();
      final doses = await db.medicineDoseDao.getTodaysDoses();
      final chsList = await db.cHSDao.getLast30Days();

      final data = {
        'exported_at': DateTime.now().toIso8601String(),
        'profile': profile != null
            ? {
                'name': profile.name,
                'date_of_birth': profile.dateOfBirth.toIso8601String(),
                'blood_group': profile.bloodGroup,
                'conditions': profile.activeConditions,
                'allergies': profile.allergies,
                'emergency_contact': {
                  'name': profile.emergencyContactName,
                  'phone': profile.emergencyContactPhone,
                  'relation': profile.emergencyContactRelation,
                },
              }
            : null,
        'vitals': vitals
            .map((v) => {
                  'logged_at': v.loggedAt.toIso8601String(),
                  'bp_systolic': v.bpSystolic,
                  'bp_diastolic': v.bpDiastolic,
                  'blood_sugar_fasting': v.bloodSugarFasting,
                  'blood_sugar_post_meal': v.bloodSugarPostMeal,
                  'temperature_celsius': v.temperatureCelsius,
                  'weight_kg': v.weightKg,
                  'spo2_percent': v.spo2Percent,
                  'notes': v.notes,
                })
            .toList(),
        'medicines': medicines
            .map((m) => {
                  'name': m.name,
                  'dosage': m.dosage,
                  'frequency': m.frequency,
                  'times_per_day': m.timesPerDay,
                  'is_active': m.isActive,
                  'start_date': m.startDate.toIso8601String(),
                  'end_date': m.endDate?.toIso8601String(),
                })
            .toList(),
        'doses': doses
            .map((d) => {
                  'scheduled_at': d.dose.scheduledAt.toIso8601String(),
                  'status': d.dose.status,
                  'medicine': d.medicine.name,
                })
            .toList(),
        'symptoms': symptoms
            .map((s) => {
                  'symptom': s.symptomName,
                  'severity': s.severity,
                  'notes': s.notes,
                  'logged_at': s.loggedAt.toIso8601String(),
                })
            .toList(),
        'doctor_visits': visits
            .map((v) => {
                  'doctor': v.doctorName,
                  'specialty': v.specialty,
                  'clinic': v.clinicOrHospital,
                  'visit_date': v.visitDate.toIso8601String(),
                  'follow_up': v.followUpDate?.toIso8601String(),
                  'notes': v.notes,
                })
            .toList(),
        'companion_health_scores': chsList
            .map((c) => {
                  'calculated_at': c.calculatedAt.toIso8601String(),
                  'score': c.score,
                  'logging_factor': c.loggingFactor,
                  'vitals_factor': c.vitalsFactor,
                  'adherence_factor': c.adherenceFactor,
                })
            .toList(),
      };

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/meditrack_export.json');
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _SectionHeader(title: 'Profile'),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryTeal,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Edit Profile'),
            subtitle: profileAsync.when(
              data: (p) => p != null ? Text(p.name) : const Text('Set up your profile'),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Error loading profile'),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/edit-profile'),
          ),
          const Divider(),
          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Medicine Reminders'),
            subtitle: const Text('Daily dose reminders'),
            value: _medicinesEnabled,
            onChanged: (v) => _toggleNotif('notif_medicines', v),
          ),
          SwitchListTile(
            title: const Text('Follow-up Reminders'),
            subtitle: const Text('Upcoming appointment alerts'),
            value: _followUpsEnabled,
            onChanged: (v) => _toggleNotif('notif_followups', v),
          ),
          ListTile(
            title: const Text('Test Notification'),
            subtitle: const Text('Send a test alert to verify notifications'),
            leading: const Icon(Icons.notification_add),
            onTap: () async {
              await NotificationService.showTestNotification();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent')),
                );
              }
            },
          ),
          const Divider(),
          _SectionHeader(title: 'Data'),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sync Now'),
            subtitle: Text(_lastSynced),
            trailing: _syncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.tonal(
                    onPressed: _syncNow,
                    child: const Text('Sync'),
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export All Data as JSON'),
            subtitle: const Text('Save a complete backup of your data'),
            trailing: _exporting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.tonal(
                    onPressed: _exportJson,
                    child: const Text('Export'),
                  ),
          ),
          const Divider(),
          _SectionHeader(title: 'Units'),
          ListTile(
            leading: const Icon(Icons.science),
            title: const Text('Blood Sugar Unit'),
            subtitle: Text(_bloodSugarUnit),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'mg/dL', label: Text('mg/dL')),
                ButtonSegment(value: 'mmol/L', label: Text('mmol/L')),
              ],
              selected: {_bloodSugarUnit},
              onSelectionChanged: (v) => _setBloodSugarUnit(v.first),
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: Text(_themeModeLabel(themeMode.mode)),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ],
              selected: {themeMode.mode},
              onSelectionChanged: (v) => themeMode.setMode(v.first),
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'Emergency'),
          ListTile(
            leading: const Icon(Icons.emergency, color: AppColors.critical),
            title: const Text('Edit Emergency Contact'),
            subtitle: const Text('Set SOS recipient and test alert'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/emergency-contact'),
          ),
          const Divider(),
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('MediTrack'),
            subtitle: const Text('Version 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.group),
            title: Text('Built by Team MerlinDevs'),
            subtitle: const Text('DevFusion 3.O | The Developers Hackathon'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryTeal,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
