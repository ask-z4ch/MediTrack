import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../core/constants/app_colors.dart';

class PrescriptionViewerScreen extends StatefulWidget {
  final List<String> prescriptionPaths;
  const PrescriptionViewerScreen({super.key, required this.prescriptionPaths});

  @override
  State<PrescriptionViewerScreen> createState() => _PrescriptionViewerScreenState();
}

class _PrescriptionViewerScreenState extends State<PrescriptionViewerScreen> {
  late final PageController _pageCtrl;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paths = widget.prescriptionPaths;
    return Scaffold(
      appBar: AppBar(title: const Text('Prescription')),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: paths.map((path) {
                final isPdf = path.toLowerCase().endsWith('.pdf');
                if (isPdf) {
                  return PdfPreview(
                    build: (format) => File(path).readAsBytes(),
                    allowPrinting: false,
                    allowSharing: false,
                    maxPageWidth: 600,
                  );
                }
                return Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4,
                    child: Image.file(File(path)),
                  ),
                );
              }).toList(),
            ),
          ),
          if (paths.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(paths.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == i ? 10 : 7,
                    height: _currentPage == i ? 10 : 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.textSecondary,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
