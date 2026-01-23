import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetReportsUseCase implements UseCase<List<DashboardReportEntity>, GetReportsParams> {
  final DashboardRepository dashboardRepository;

  GetReportsUseCase(this.dashboardRepository);

  @override
  Future<Either<Failure, List<DashboardReportEntity>>> call(GetReportsParams params) {
    return dashboardRepository.getReports(
      limit: params.limit,
      status: params.status,
      userId: params.userId,
      lastReportId: params.lastReportId,
    );
  }
}

class GetReportsParams {
  final int limit;
  final ReportStatus? status;
  final String? userId;
  final String? lastReportId;

  GetReportsParams({
    this.lastReportId,
    this.status,
    this.userId,
    this.limit = 10,
  });
}
