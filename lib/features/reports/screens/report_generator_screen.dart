import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../services/pdf_report_service.dart';

class ReportGeneratorScreen extends ConsumerStatefulWidget {
  final DateTime? fromDate;
  const ReportGeneratorScreen({super.key, this.fromDate});

  @override
  ConsumerState<ReportGeneratorScreen> createState() =>
      _ReportGeneratorScreenState();
}

class _ReportGeneratorScreenState extends ConsumerState<ReportGeneratorScreen> {
  bool _generating = false;

  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final extra = GoRouterState.of(context).extra;
    final fromDate = widget.fromDate ?? (extra is DateTime ? extra : null);
    _from = fromDate ?? DateTime.now().subtract(const Duration(days: 30));
    _to = DateTime.now();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _from : _to;
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (d != null) {
      setState(() {
        if (isFrom) {
          _from = d;
        } else {
          _to = d;
        }
      });
    }
  }

  Future<void> _generate() async {
    if (_from.isAfter(_to)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('"From" date must be before "To" date.')),
      );
      return;
    }

    final daysDiff = _to.difference(_from).inDays;
    if (daysDiff > 90) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Large Date Range'),
          content: Text(
            'You selected a $daysDiff-day range. '
            'Report generation may be slow for large datasets. Continue?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Continue')),
          ],
        ),
      );
      if (proceed != true) return;
    }

    setState(() => _generating = true);
    try {
      final dao = ref.read(appDatabaseProvider);
      final profile = await dao.profileDao.getProfile();
      if (profile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete your profile first.')),
        );
        return;
      }
      final vitals = await dao.vitalsDao.getVitalsInRange(_from, _to);
      final medicines = await dao.medicineDao.getAllMedicines();
      final doses = await dao.medicineDoseDao.getDosesInRange(_from, _to);
      final symptoms = await dao.symptomDao.getSymptomsInRange(_from, _to);

      final bytes = await ref.read(pdfReportServiceProvider).generateReport(
        profile: profile,
        vitals: vitals,
        medicines: medicines,
        doses: doses,
        symptoms: symptoms,
        from: _from,
        to: _to,
      );

      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'meditrack_${profile.name.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Range', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'From',
                    date: _from,
                    onTap: () => _pickDate(isFrom: true),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 18),
                ),
                Expanded(
                  child: _DateTile(
                    label: 'To',
                    date: _to,
                    onTap: () => _pickDate(isFrom: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_to.difference(_from).inDays} days selected',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _generating ? null : _generate,
                icon: _generating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(_generating ? 'Generating...' : 'Generate Report'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(dateFormat.format(date)),
      ),
    );
  }
}
