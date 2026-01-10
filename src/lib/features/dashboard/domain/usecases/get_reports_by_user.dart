import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetReportsByUserUseCase implements UseCase<List<DashboardReportEntity>, GetReportsByUserParams> {
  final DashboardRepository dashboardRepository;

  GetReportsByUserUseCase(this.dashboardRepository);

  @override
  Future<Either<Failure, List<DashboardReportEntity>>> call(GetReportsByUserParams params) {
    return dashboardRepository.getReportsByUser(
      userId: params.userId,
      limit: params.limit,
      lastReportId: params.lastReportId,
    );
  }
}

class GetReportsByUserParams {
  final String userId;
  final int limit;
  String? lastReportId;

  GetReportsByUserParams({
    required this.userId,
    this.limit = 10,
    this.lastReportId,
  });
}
