import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportService {
  Future<void> generateTestPdf(String patientName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text('Hello, $patientName!', style: pw.TextStyle(fontSize: 24)),
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/test_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'test_report.pdf',
    );
  }

  Future<void> viewPdf(Uint8List bytes, String filename) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}
