import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class UpdateReportBasicInformationUseCase implements UseCase<void, UpdateReportBasicInformationParams> {
  final UserManagementRepository repository;

  UpdateReportBasicInformationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateReportBasicInformationParams params) {
    return repository.updateReportBasicInformation(
      reportId: params.reportId,
      title: params.title,
      description: params.description,
    );
  }
}

class UpdateReportBasicInformationParams {
  final String reportId;
  final String? title;
  final String? description;

  UpdateReportBasicInformationParams({
    required this.reportId,
    this.title,
    this.description,
  });
}
