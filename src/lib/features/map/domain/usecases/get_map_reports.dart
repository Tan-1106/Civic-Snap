import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';
import 'package:src/features/map/domain/repositories/map_repository.dart';

class GetMapReportsUseCase implements StreamUseCase<List<MapReportEntity>, GetMapReportsParams> {
  final MapRepository repository;

  GetMapReportsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<MapReportEntity>>> call(GetMapReportsParams params) {
    return repository.getMapReports(
      limit: params.limit,
      status: params.status,
    );
  }
}

class GetMapReportsParams {
  final int limit;
  final ReportStatus? status;

  GetMapReportsParams({
    required this.limit,
    this.status,
  });
}