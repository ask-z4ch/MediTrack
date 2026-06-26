import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      sugarUnit: prefs.getString('sugar_unit') ?? 'mgdl',
      theme: prefs.getString('theme') ?? 'system',
    );
  }

  Future<void> setSugarUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sugar_unit', unit);
    ref.invalidateSelf();
  }
}
