import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetReportsUseCase implements UseCase<List<DashboardReportEntity>, GetReportsParams> {
  final DashboardRepository dashboardRepository;

  GetReportsUseCase(this.dashboardRepository);

  @override
  Future<Either<Failure, List<DashboardReportEntity>>> call(GetReportsParams params) {
    return dashboardRepository.getReports(
      limit: params.limit,
      lastReportId: params.lastReportId,
    );
  }
}

class GetReportsParams {
  final int limit;
  String? lastReportId;

  GetReportsParams({
    this.lastReportId,
    this.limit = 10,
  });
}
