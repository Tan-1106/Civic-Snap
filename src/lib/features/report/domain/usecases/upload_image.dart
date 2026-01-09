import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/report/domain/repositories/report_repository.dart';

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final ReportRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return repository.uploadImage(
      image: params.image,
      reportId: params.reportId,
    );
  }
}

class UploadImageParams {
  final File image;
  final String reportId;

  UploadImageParams({
    required this.image,
    required this.reportId,
  });
}
