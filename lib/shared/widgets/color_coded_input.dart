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
  final VitalStatus Function(double?)? thresholdEvaluator;

  const ColorCodedInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.thresholdEvaluator,
  });

  @override
  State<ColorCodedInput> createState() => _ColorCodedInputState();
}

class _ColorCodedInputState extends State<ColorCodedInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(widget.controller.text);
    final status = widget.thresholdEvaluator?.call(value) ?? VitalStatus.normal;
    final borderColor = value == null
        ? Colors.grey
        : status == VitalStatus.critical
            ? AppColors.criticalRed
            : status == VitalStatus.borderline
                ? AppColors.borderlineAmber
                : AppColors.normalGreen;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: widget.suffix,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: 2)),
      ),
    );
  }
}
