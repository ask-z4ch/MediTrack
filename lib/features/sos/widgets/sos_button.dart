import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/providers/profile_provider.dart';
import '../services/sos_service.dart';

class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key});

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _fillController;
  Timer? _activationTimer;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _fillController.dispose();
    _activationTimer?.cancel();
    super.dispose();
  }

  void _onHoldStart() {
    _holding = true;
    _fillController.forward();
    _activationTimer = Timer(const Duration(seconds: 2), () {
      if (_holding) _triggerSosConfirmation();
    });
  }

  void _onHoldEnd() {
    _holding = false;
    _fillController.reverse();
    _activationTimer?.cancel();
  }

  Future<void> _triggerSosConfirmation() async {
    if (!mounted) return;
    _fillController.reset();
    _holding = false;

    final profile = ref.read(profileNotifierProvider).valueOrNull;
    if (profile == null ||
        profile.emergencyContactPhone == null ||
        profile.emergencyContactPhone!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set an emergency contact first in Settings.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('SOS Alert'),
          ],
        ),
        content: Text(
          'Send an SOS alert to ${profile.emergencyContactName ?? "your emergency contact"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await SosService().sendSos(profile: profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onHoldStart(),
      onTapUp: (_) => _onHoldEnd(),
      onTapCancel: _onHoldEnd,
      child: AnimatedBuilder(
        animation: _fillController,
        builder: (context, child) {
          return SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _fillController.value,
                  strokeWidth: 64,
                  backgroundColor: Colors.red.shade700,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.redAccent,
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sos, color: Colors.white, size: 26),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
