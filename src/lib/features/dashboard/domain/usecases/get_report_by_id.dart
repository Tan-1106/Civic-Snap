import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetReportByIdUseCase implements UseCase<DashboardReportEntity, GetReportByIdParams> {
  final DashboardRepository repository;

  GetReportByIdUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardReportEntity>> call(GetReportByIdParams params) {
    return repository.getReportById(params.reportId);
  }
}

class GetReportByIdParams {
  final String reportId;

  GetReportByIdParams({required this.reportId});
}