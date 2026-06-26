import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';

class SOSService {
  Future<void> sendSOS({
    required UserProfile profile,
    required String contactPhone,
    bool isTest = false,
  }) async {
    Position? position;
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      // GPS unavailable — send SOS without coordinates
    }

    final message = _buildSOSMessage(profile, position, isTest: isTest);
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('sms:$contactPhone?body=$encoded');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _buildSOSMessage(
    UserProfile profile,
    Position? position, {
    bool isTest = false,
  }) {
    final buf = StringBuffer();
    if (isTest) buf.writeln('[TEST MESSAGE — IGNORE IF UNEXPECTED]');
    buf.writeln('🆘 EMERGENCY — ${profile.name} needs immediate help');
    buf.writeln('Blood Group: ${profile.bloodGroup ?? "Unknown"}');
    if (profile.activeConditions.isNotEmpty) {
      buf.writeln('Medical Conditions: ${profile.activeConditions}');
    }
    if (profile.allergies.isNotEmpty) {
      buf.writeln('Allergies: ${profile.allergies}');
    }
    if (position != null) {
      buf.writeln(
        'Location: https://maps.google.com/?q=${position.latitude},${position.longitude}',
      );
    } else {
      buf.writeln('Location: Could not be determined');
    }
    buf.writeln(
        'Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}');
    buf.writeln('— Sent via MediTrack');
    return buf.toString();
  }
}
