import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<DashboardReportEntity>>> getReports({
    required int limit,
    ReportStatus? status,
    String? userId,
    String? lastReportId,
  }) async {
    try {
      final reports = await remoteDataSource.getReports(
        limit: limit,
        status: status,
        userId: userId,
        lastDocumentId: lastReportId,
      );
      return right(reports.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardReportEntity>> getReportById(String reportId) async {
    try {
      final report = await remoteDataSource.getReportById(reportId);
      return right(report.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  }) async {
    try {
      final result = await remoteDataSource.respondToReport(
        reportId: reportId,
        newStatus: newStatus,
        response: response,
      );
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}