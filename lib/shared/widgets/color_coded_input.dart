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
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsets scrollPadding;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const ColorCodedInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.statusEvaluator,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.scrollPadding = const EdgeInsets.all(20),
    this.validator,
    this.autovalidateMode,
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
      filled: true,
      fillColor: AppColors.cardSurface,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
      decoration: _decoration(_status).copyWith(
        errorStyle: const TextStyle(color: AppColors.critical, fontSize: 12),
      ),
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      scrollPadding: widget.scrollPadding,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
