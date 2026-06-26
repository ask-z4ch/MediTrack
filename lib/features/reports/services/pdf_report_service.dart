import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';

part 'pdf_report_service.g.dart';

@riverpod
PdfReportService pdfReportService(PdfReportServiceRef ref) {
  return PdfReportService();
}

class PdfReportService {
  Future<Uint8List> generateReport({
    required UserProfile profile,
    required List<VitalsEntry> vitals,
    required List<Medicine> medicines,
    required List<MedicineDose> doses,
    required List<SymptomEntry> symptoms,
    required DateTime from,
    required DateTime to,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (ctx) => _buildPageHeader(profile),
        footer: (ctx) => _buildPageFooter(ctx),
        build: (ctx) => [
          _buildReportHeader(profile, from, to),
          pw.SizedBox(height: 16),
          _buildVitalsSection(vitals),
          pw.SizedBox(height: 16),
          _buildMedicinesSection(medicines, doses),
          pw.SizedBox(height: 16),
          _buildSymptomsSection(symptoms),
          pw.SizedBox(height: 16),
          _buildDisclaimer(),
        ],
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildPageHeader(UserProfile profile) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('MediTrack', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(profile.name, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
      ],
    );
  }

  pw.Widget _buildPageFooter(pw.Context ctx) {
    return pw.Text(
      'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
      style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
    );
  }

  pw.Widget _buildReportHeader(UserProfile p, DateTime from, DateTime to) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('MediTrack Health Summary',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal700,
                    )),
                pw.SizedBox(height: 4),
                pw.Text('Patient: ${p.name}',
                    style: const pw.TextStyle(fontSize: 13)),
                pw.Text('Blood Group: ${p.bloodGroup ?? "Not recorded"}'),
                if (p.activeConditions.isNotEmpty)
                  pw.Text('Conditions: ${p.activeConditions}'),
                if (p.allergies.isNotEmpty)
                  pw.Text('Allergies: ${p.allergies}'),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Report Period',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${_fmtDate(from)} — ${_fmtDate(to)}'),
                pw.SizedBox(height: 8),
                pw.Text('Generated: ${_fmtDate(DateTime.now())}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    )),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 1.5, color: PdfColors.teal700),
      ],
    );
  }

  String _fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  pw.Widget _buildVitalsSection(List<VitalsEntry> vitals) {
    if (vitals.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          'No vitals were logged in this date range.',
          style: const pw.TextStyle(color: PdfColors.grey600),
        ),
      );
    }

    final systolicVals = vitals
        .where((e) => e.bpSystolic != null)
        .map((e) => e.bpSystolic!.toDouble())
        .toList();
    final diastolicVals = vitals
        .where((e) => e.bpDiastolic != null)
        .map((e) => e.bpDiastolic!.toDouble())
        .toList();
    final fastingVals = vitals
        .where((e) => e.bloodSugarFasting != null)
        .map((e) => e.bloodSugarFasting!)
        .toList();
    final postMealVals = vitals
        .where((e) => e.bloodSugarPostMeal != null)
        .map((e) => e.bloodSugarPostMeal!)
        .toList();
    final spo2Vals = vitals
        .where((e) => e.spo2Percent != null)
        .map((e) => e.spo2Percent!.toDouble())
        .toList();
    final tempVals = vitals
        .where((e) => e.temperatureCelsius != null)
        .map((e) => e.temperatureCelsius!)
        .toList();
    final weightVals = vitals
        .where((e) => e.weightKg != null)
        .map((e) => e.weightKg!)
        .toList();

    double avg(List<double> vals) =>
        vals.isEmpty ? 0 : vals.reduce((a, b) => a + b) / vals.length;
    double minV(List<double> vals) =>
        vals.isEmpty ? 0 : vals.reduce((a, b) => a < b ? a : b);
    double maxV(List<double> vals) =>
        vals.isEmpty ? 0 : vals.reduce((a, b) => a > b ? a : b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Vitals Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1.5),
          },
          children: [
            _tableHeaderRow(['Vital', 'Avg', 'Min', 'Max', 'Status']),
            if (systolicVals.isNotEmpty)
              _tableDataRow([
                'BP Systolic',
                '${avg(systolicVals).toStringAsFixed(0)}',
                '${minV(systolicVals).toStringAsFixed(0)}',
                '${maxV(systolicVals).toStringAsFixed(0)}',
                _bpStatus(avg(systolicVals)),
              ]),
            if (diastolicVals.isNotEmpty)
              _tableDataRow([
                'BP Diastolic',
                '${avg(diastolicVals).toStringAsFixed(0)}',
                '${minV(diastolicVals).toStringAsFixed(0)}',
                '${maxV(diastolicVals).toStringAsFixed(0)}',
                _bpDiastolicStatus(avg(diastolicVals)),
              ]),
            if (fastingVals.isNotEmpty)
              _tableDataRow([
                'Sugar Fasting',
                '${avg(fastingVals).toStringAsFixed(1)}',
                '${minV(fastingVals).toStringAsFixed(1)}',
                '${maxV(fastingVals).toStringAsFixed(1)}',
                _sugarStatus(avg(fastingVals), isFasting: true),
              ]),
            if (postMealVals.isNotEmpty)
              _tableDataRow([
                'Sugar Post-Meal',
                '${avg(postMealVals).toStringAsFixed(1)}',
                '${minV(postMealVals).toStringAsFixed(1)}',
                '${maxV(postMealVals).toStringAsFixed(1)}',
                _sugarStatus(avg(postMealVals), isFasting: false),
              ]),
            if (spo2Vals.isNotEmpty)
              _tableDataRow([
                'SpO2',
                '${avg(spo2Vals).toStringAsFixed(0)}%',
                '${minV(spo2Vals).toStringAsFixed(0)}%',
                '${maxV(spo2Vals).toStringAsFixed(0)}%',
                _spo2Status(avg(spo2Vals)),
              ]),
            if (tempVals.isNotEmpty)
              _tableDataRow([
                'Temperature',
                '${avg(tempVals).toStringAsFixed(1)}°C',
                '${minV(tempVals).toStringAsFixed(1)}°C',
                '${maxV(tempVals).toStringAsFixed(1)}°C',
                _tempStatus(avg(tempVals)),
              ]),
            if (weightVals.isNotEmpty)
              _tableDataRow([
                'Weight',
                '${avg(weightVals).toStringAsFixed(1)} kg',
                '${minV(weightVals).toStringAsFixed(1)}',
                '${maxV(weightVals).toStringAsFixed(1)}',
                '—',
              ]),
          ],
        ),
      ],
    );
  }

  pw.Widget _cellText(String text, {pw.TextStyle? style}) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text,
          style: style ?? const pw.TextStyle(fontSize: 9),
          overflow: pw.TextOverflow.ellipsis),
    );
  }

  pw.TableRow _tableHeaderRow(List<String> cells) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.blue50),
      children: cells
          .map((c) => _cellText(c,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 9)))
          .toList(),
    );
  }

  pw.TableRow _tableDataRow(List<String> cells) {
    return pw.TableRow(
      children:
          cells.map((c) => _cellText(c)).toList(),
    );
  }

  String _bpStatus(double avgSystolic) {
    if (avgSystolic <= 120) return 'Normal';
    if (avgSystolic <= 139) return 'Borderline';
    return 'Critical';
  }

  String _bpDiastolicStatus(double avgDiastolic) {
    if (avgDiastolic <= 80) return 'Normal';
    if (avgDiastolic <= 89) return 'Borderline';
    return 'Critical';
  }

  String _sugarStatus(double avg, {required bool isFasting}) {
    final threshold = isFasting ? 100.0 : 140.0;
    final borderline = isFasting ? 125.0 : 199.0;
    if (avg <= threshold) return 'Normal';
    if (avg <= borderline) return 'Borderline';
    return 'Critical';
  }

  String _spo2Status(double avg) {
    if (avg >= 95) return 'Normal';
    if (avg >= 92) return 'Borderline';
    return 'Critical';
  }

  String _tempStatus(double avg) {
    if (avg >= 36.5 && avg <= 37.5) return 'Normal';
    if (avg > 37.5 && avg <= 38.3) return 'Borderline';
    if (avg < 36.5 && avg >= 35.5) return 'Borderline';
    return 'Critical';
  }

  pw.Widget _buildMedicinesSection(List<Medicine> medicines, List<MedicineDose> doses) {
    if (medicines.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          'No medicines were prescribed in this date range.',
          style: const pw.TextStyle(color: PdfColors.grey600),
        ),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Medication Adherence',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1.2),
            2: const pw.FlexColumnWidth(1.2),
            3: const pw.FlexColumnWidth(1.2),
            4: const pw.FlexColumnWidth(1.2),
            5: const pw.FlexColumnWidth(1.2),
          },
          children: [
            _tableHeaderRow(
                ['Medicine', 'Dosage', 'Freq', 'Scheduled', 'Taken', 'Adherence']),
            ...medicines.where((m) => m.isActive).map((m) {
              final scheduled =
                  doses.where((d) => d.medicineId == m.id).length;
              final taken = doses
                  .where((d) => d.medicineId == m.id && d.status == 'taken')
                  .length;
              final adherence =
                  scheduled == 0 ? 100.0 : (taken / scheduled) * 100;
              final adherenceLabel = '${adherence.round()}%';
              final adherenceColor = adherence >= 80
                  ? PdfColors.green700
                  : adherence >= 50
                      ? PdfColors.orange700
                      : PdfColors.red700;
              final freqLabel = m.frequency == 'once_daily'
                  ? '1x/day'
                  : m.frequency == 'twice_daily'
                      ? '2x/day'
                      : m.frequency == 'three_times_daily'
                          ? '3x/day'
                          : '${m.timesPerDay}x/day';
              return pw.TableRow(
                children: [
                  _cell(m.name),
                  _cell(m.dosage),
                  _cell(freqLabel),
                  _cell(scheduled.toString()),
                  _cell(taken.toString()),
                  _cellText(adherenceLabel,
                      style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: adherenceColor)),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _cell(String text) => _cellText(text);

  pw.Widget _buildSymptomsSection(List<SymptomEntry> symptoms) {
    if (symptoms.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          'No symptoms were logged in this date range.',
          style: const pw.TextStyle(color: PdfColors.grey600),
        ),
      );
    }
    final grouped = <String, List<SymptomEntry>>{};
    for (final s in symptoms) {
      grouped.putIfAbsent(s.symptomName, () => []).add(s);
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Symptoms Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2.5),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(1.5),
          },
          children: [
            _tableHeaderRow(['Symptom', 'Times Logged', 'Avg Severity']),
            ...grouped.entries.map((e) {
              final avg =
                  e.value.map((s) => s.severity).reduce((a, b) => a + b) /
                      e.value.length;
              return _tableDataRow([
                e.key,
                e.value.length.toString(),
                avg.toStringAsFixed(1),
              ]);
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDisclaimer() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Text(
        'This report is not a medical diagnosis. Share this with your doctor for informed consultation.',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }
}
