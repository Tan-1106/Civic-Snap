import 'package:fpdart/fpdart.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/features/map/data/datasources/map_remote_data_source.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';
import 'package:src/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Either<Failure, List<MapReportEntity>>> getMapReports({
    required int limit,
    ReportStatus? status,
  }) {
    try {
      return remoteDataSource.getMapReports(
        limit: limit,
        status: status,
      ).map((reports) => right(reports.map((e) => e.toEntity()).toList()));
    } catch (e) {
      return Stream.value(left(Failure(e.toString())));
    }
  }
}