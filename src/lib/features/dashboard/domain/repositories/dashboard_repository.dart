import 'package:fpdart/fpdart.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, List<DashboardReportEntity>>> getReports({
    required int limit,
    String? lastReportId,
  });

  Future<Either<Failure, DashboardReportEntity>> getReportById(String reportId);

  Future<Either<Failure, List<DashboardReportEntity>>> getReportsByStatus({
    required ReportStatus status,
    required int limit,
    String? lastReportId,
  });

  Future<Either<Failure, List<DashboardReportEntity>>> getReportsByUser({
    required String userId,
    required int limit,
    String? lastReportId,
  });
}
