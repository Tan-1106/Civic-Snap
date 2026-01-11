import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/report/domain/usecases/submit_report.dart';
import 'package:src/features/report/domain/usecases/upload_image.dart';

class ReportProvider extends ChangeNotifier {
  final UploadImageUseCase _uploadImageUseCase;
  final SubmitReportUseCase _submitReportUseCase;

  ReportProvider(
    UploadImageUseCase uploadImageUseCase,
    SubmitReportUseCase submitReportUseCase,
  ) : _uploadImageUseCase = uploadImageUseCase,
      _submitReportUseCase = submitReportUseCase;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> submitReport({
    required String userId,
    required String title,
    required String description,
    required File image,
    required Position position,
  }) async {
    _isLoading = true;
    notifyListeners();

    final reportId = userId + DateTime.now().millisecondsSinceEpoch.toString();

    final uploadImageResult = await _uploadImageUseCase(UploadImageParams(image: image, reportId: reportId));
    uploadImageResult.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (imageUrl) async {
        final submitReportResult = await _submitReportUseCase(
          SubmitReportParams(
            id: reportId,
            userId: userId,
            title: title,
            description: description,
            imageUrl: imageUrl,
            createdAt: DateTime.now(),
            status: ReportStatus.pending.displayName,
            location: GeoPoint(position.latitude, position.longitude),
          ),
        );

        submitReportResult.fold(
          (failure) {
            _errorMessage = failure.message;
          },
          (_) {},
        );
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
