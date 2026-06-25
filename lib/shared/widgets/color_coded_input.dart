import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/health_thresholds.dart';

class ColorCodedInput extends StatefulWidget {
  final String label;
  final String suffix;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VitalStatus Function(String) statusEvaluator;

  const ColorCodedInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.statusEvaluator,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
  });

  @override
  State<ColorCodedInput> createState() => _ColorCodedInputState();
}

class _ColorCodedInputState extends State<ColorCodedInput> {
  VitalStatus _status = VitalStatus.normal;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _onChanged();
  }

  void _onChanged() {
    setState(() {
      _status = widget.statusEvaluator(widget.controller.text);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  InputDecoration _decoration(VitalStatus status) {
    final color = switch (status) {
      VitalStatus.normal => AppColors.normal,
      VitalStatus.borderline => AppColors.borderline,
      VitalStatus.critical => AppColors.critical,
    };
    return InputDecoration(
      labelText: widget.label,
      suffixText: widget.suffix,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: _decoration(_status),
    );
  }
}
