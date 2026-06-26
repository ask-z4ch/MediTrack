import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
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

    int countdown = 5;
    Timer? countdownTimer;
    bool cancelled = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          countdownTimer ??= Timer.periodic(
            const Duration(seconds: 1),
            (t) {
              if (countdown <= 1) {
                t.cancel();
                Navigator.of(ctx).pop();
                if (!cancelled) _sendSos(profile);
              } else {
                setDialogState(() => countdown--);
              }
            },
          );
          return AlertDialog(
            title: const Text('Sending SOS'),
            content: Text(
              'Emergency contact will be notified in $countdown seconds.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  cancelled = true;
                  countdownTimer?.cancel();
                  Navigator.of(ctx).pop();
                },
                child: const Text('CANCEL',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sendSos(UserProfile profile) async {
    if (!mounted) return;
    await SosService().sendSos(profile: profile);
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
