import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class RespondToReportUseCase implements UseCase<bool, RespondToReportParams> {
  final DashboardRepository dashboardRepository;

  RespondToReportUseCase(this.dashboardRepository);

  @override
  Future<Either<Failure, bool>> call(RespondToReportParams params) {
    return dashboardRepository.respondToReport(
      reportId: params.reportId,
      newStatus: params.newStatus,
      response: params.response,
    );
  }
}

class RespondToReportParams {
  final String reportId;
  final ReportStatus? newStatus;
  final String? response;

  RespondToReportParams({
    required this.reportId,
    this.newStatus,
    this.response,
  });
}
