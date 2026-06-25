import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/app_database.dart';

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

  pw.Widget _buildReportHeader(UserProfile profile, DateTime from, DateTime to) {
    final dateFormat = DateFormat('d MMMM yyyy');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Health Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(profile.name, style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
        if (profile.dateOfBirth != null)
          pw.Text('DOB: ${dateFormat.format(profile.dateOfBirth!)}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text('${dateFormat.format(from)} — ${dateFormat.format(to)}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
      ],
    );
  }

  pw.Widget _buildVitalsSection(List<VitalsEntry> vitals) {
    if (vitals.isEmpty) return pw.Text('No vitals recorded in this period.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500));
    final dateFormat = DateFormat('d MMM yyyy, HH:mm');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Vitals', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
          cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.center, 3: pw.Alignment.center, 4: pw.Alignment.center},
          columnWidths: {0: const pw.FixedColumnWidth(100), 1: const pw.FixedColumnWidth(45), 2: const pw.FixedColumnWidth(45), 3: const pw.FixedColumnWidth(45), 4: const pw.FixedColumnWidth(60)},
          headers: ['Date', 'BP', 'Sugar F', 'Sugar P', 'SpO2'],
          data: vitals.map((v) => [
            dateFormat.format(v.loggedAt),
            v.bpSystolic != null ? '${v.bpSystolic}/${v.bpDiastolic}' : '—',
            v.bloodSugarFasting?.toStringAsFixed(1) ?? '—',
            v.bloodSugarPostMeal?.toStringAsFixed(1) ?? '—',
            v.spo2Percent?.toString() ?? '—',
          ]).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildMedicinesSection(List<Medicine> medicines, List<MedicineDose> doses) {
    if (medicines.isEmpty) return pw.Text('No medicines prescribed.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500));
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Medicines', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        ...medicines.map((m) {
          final medicineDoses = doses.where((d) => d.medicineId == m.id).toList();
          final taken = medicineDoses.where((d) => d.status == 'taken').length;
          final total = medicineDoses.length;
          final adherence = total > 0 ? (taken / total * 100).round() : null;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${m.name} — ${m.dosage}', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  if (adherence != null)
                    pw.Text('$adherence% adherence', style: pw.TextStyle(fontSize: 9, color: adherence >= 80 ? PdfColors.green700 : PdfColors.orange700)),
                ],
              ),
              pw.Text('${m.timesPerDay}x/day', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              pw.SizedBox(height: 4),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildSymptomsSection(List<SymptomEntry> symptoms) {
    if (symptoms.isEmpty) return pw.Text('No symptoms logged.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500));
    final dateFormat = DateFormat('d MMM yyyy, HH:mm');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Symptoms', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.orange50),
          cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.centerLeft},
          columnWidths: {0: const pw.FixedColumnWidth(100), 1: const pw.FixedColumnWidth(45), 2: const pw.FixedColumnWidth(150)},
          headers: ['Date', 'Severity', 'Symptom'],
          data: symptoms.map((s) => [
            dateFormat.format(s.loggedAt),
            s.severity.toString(),
            s.symptomName,
          ]).toList(),
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
        'This report is generated for informational purposes only and does not constitute medical advice. '
        'Always consult your healthcare provider for medical decisions.',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }
}
