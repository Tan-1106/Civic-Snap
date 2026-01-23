import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report.dart';

abstract interface class DashboardRepository {
  // Fetch reports with optional filters: status, userId, pagination
  Future<Either<Failure, List<DashboardReportEntity>>> getReports({
    required int limit,
    ReportStatus? status,
    String? userId,
    String? lastReportId,
  });

  // Respond to a report by updating its status and adding a response message
  Future<Either<Failure, void>> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  });
}
