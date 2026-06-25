import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/services/notification_service.dart';
import '../providers/doctor_visit_provider.dart';

class AddDoctorVisitScreen extends ConsumerStatefulWidget {
  const AddDoctorVisitScreen({super.key});

  @override
  ConsumerState<AddDoctorVisitScreen> createState() => _AddDoctorVisitScreenState();
}

class _AddDoctorVisitScreenState extends ConsumerState<AddDoctorVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _clinicCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _visitDate = DateTime.now();
  DateTime? _followUpDate;
  bool _noFollowUp = true;
  List<String> _prescriptionPaths = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specialtyCtrl.dispose();
    _clinicCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickVisitDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _visitDate = d);
  }

  Future<void> _pickFollowUpDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? _visitDate.add(const Duration(days: 30)),
      firstDate: _visitDate.add(const Duration(days: 1)),
      lastDate: _visitDate.add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _followUpDate = d);
  }

  Future<String> _savePrescriptionToDocuments(
    String sourcePath,
    String ext,
  ) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final prescDir = Directory('${docsDir.path}/prescriptions');
    if (!await prescDir.exists()) {
      await prescDir.create(recursive: true);
    }
    final fileName = '${const Uuid().v4()}$ext';
    final destPath = '${prescDir.path}/$fileName';
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (photo == null) return;
    final savedPath = await _savePrescriptionToDocuments(photo.path, '.jpg');
    setState(() => _prescriptionPaths.add(savedPath));
  }

  Future<void> _importPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;
    final savedPath = await _savePrescriptionToDocuments(result.files.single.path!, '.pdf');
    setState(() => _prescriptionPaths.add(savedPath));
  }

  Future<void> _deletePrescription(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
    setState(() => _prescriptionPaths.remove(filePath));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(doctorVisitDaoProvider);
    final visitId = await dao.insertVisit(
      DoctorVisitsCompanion(
        doctorName: Value(_nameCtrl.text.trim()),
        specialty: Value(_specialtyCtrl.text.trim()),
        clinicOrHospital: Value(_clinicCtrl.text.trim()),
        visitDate: Value(_visitDate),
        followUpDate: _noFollowUp ? const Value(null) : Value(_followUpDate),
        notes: Value(_notesCtrl.text.trim()),
        prescriptionPaths: Value(jsonEncode(_prescriptionPaths)),
      ),
    );

    if (!_noFollowUp && _followUpDate != null) {
      final reminderTime = _followUpDate!
          .subtract(const Duration(days: 1))
          .copyWith(hour: 9, minute: 0);
      if (reminderTime.isAfter(DateTime.now())) {
        await NotificationService.scheduleOneTimeReminder(
          id: visitId + 10000,
          title: 'Doctor Follow-Up Tomorrow',
          body: 'Your appointment with Dr. ${_nameCtrl.text.trim()} is tomorrow.',
          scheduledAt: reminderTime,
        );
      }
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor Visit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialtyCtrl,
              decoration: const InputDecoration(
                labelText: 'Specialty',
                hintText: 'e.g. Cardiologist, GP',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clinicCtrl,
              decoration: const InputDecoration(
                labelText: 'Clinic / Hospital',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Text('Visit Date', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            ListTile(
              title: Text(
                '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickVisitDate,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('No follow-up'),
              value: _noFollowUp,
              onChanged: (v) => setState(() => _noFollowUp = v),
            ),
            if (!_noFollowUp)
              ListTile(
                title: Text(
                  _followUpDate != null
                      ? '${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}'
                      : 'Select follow-up date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickFollowUpDate,
              ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Text('Prescriptions', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _capturePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _importPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Import PDF'),
                  ),
                ),
              ],
            ),
            if (_prescriptionPaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _prescriptionPaths.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final path = _prescriptionPaths[index];
                    final isPdf = path.endsWith('.pdf');
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: isPdf
                              ? const Icon(Icons.picture_as_pdf, size: 40)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    cacheWidth: 160,
                                    cacheHeight: 160,
                                  ),
                                ),
                        ),
                        Positioned(
                          right: -6,
                          top: -6,
                          child: GestureDetector(
                            onTap: () => _deletePrescription(path),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Visit'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
