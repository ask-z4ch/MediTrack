import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';

class SosService {
  Future<void> sendSos({
    required UserProfile profile,
  }) async {
    final phone = profile.emergencyContactPhone;
    if (phone == null || phone.isEmpty) return;

    final name = profile.emergencyContactName ?? 'Emergency Contact';
    final relation = profile.emergencyContactRelation ?? '';

    final buffer = StringBuffer();
    buffer.writeln('SOS ALERT from MediTrack — $name ($relation) needs help!');
    buffer.writeln();

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      buffer.writeln('Location: https://maps.google.com/maps?q=${pos.latitude},${pos.longitude}');
      buffer.writeln('Accuracy: ${pos.accuracy?.round()}m');
    } catch (_) {
      buffer.writeln('(Location unavailable)');
    }

    buffer.writeln('This is an automated SOS from MediTrack.');

    final uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': buffer.toString()},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
