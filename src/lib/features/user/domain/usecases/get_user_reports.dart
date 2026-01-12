import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class GetUserReportsUseCase implements UseCase<List<UserReportEntity>, GetUserReportsParams> {
  final UserManagementRepository repository;

  GetUserReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserReportEntity>>> call(GetUserReportsParams params) {
    return repository.getUserReports(
      limit: params.limit,
      userId: params.userId,
      status: params.status,
      lastReportId: params.lastReportId,
    );
  }
}

class GetUserReportsParams {
  final int limit;
  final String userId;
  final ReportStatus? status;
  final String? lastReportId;

  GetUserReportsParams({
    required this.limit,
    required this.userId,
    this.status,
    this.lastReportId,
  });
}

