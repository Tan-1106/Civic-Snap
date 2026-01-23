import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class DeleteReportUseCase implements UseCase<void, DeleteReportParams> {
  final UserManagementRepository repository;

  DeleteReportUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteReportParams params) {
    return repository.deleteReport(reportId: params.reportId);
  }
}

class DeleteReportParams {
  final String reportId;

  DeleteReportParams({
    required this.reportId,
  });
}

