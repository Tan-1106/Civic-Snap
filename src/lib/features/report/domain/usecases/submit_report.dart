import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/report/domain/repositories/report_repository.dart';

class SubmitReportUseCase implements UseCase<void, SubmitReportParams> {
  final ReportRepository reportRepository;

  SubmitReportUseCase(this.reportRepository);

  @override
  Future<Either<Failure, void>> call(SubmitReportParams params) {
    return reportRepository.submitReport(
      id: params.id,
      userId: params.userId,
      title: params.title,
      description: params.description,
      imageUrl: params.imageUrl,
      createdAt: params.createdAt,
      status: params.status,
      location: params.location,
    );
  }
}

class SubmitReportParams {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final GeoPoint location;

  SubmitReportParams({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
  });
}