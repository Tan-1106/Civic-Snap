import 'package:fpdart/fpdart.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetReportsByStatusUseCase implements UseCase<List<DashboardReportEntity>, GetReportsByStatusParams> {
  final DashboardRepository dashboardRepository;

  GetReportsByStatusUseCase(this.dashboardRepository);

  @override
  Future<Either<Failure, List<DashboardReportEntity>>> call(GetReportsByStatusParams params) {
    return dashboardRepository.getReportsByStatus(
      status: params.status,
      limit: params.limit,
      lastReportId: params.lastReportId,
    );
  }
}

class GetReportsByStatusParams {
  final ReportStatus status;
  final int limit;
  String? lastReportId;

  GetReportsByStatusParams({
    this.status = ReportStatus.pending,
    this.limit = 10,
    this.lastReportId,
  });
}
