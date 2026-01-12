import 'package:fpdart/fpdart.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';

abstract interface class MapRepository {
  Stream<Either<Failure, List<MapReportEntity>>> getMapReports({
    required int limit,
    ReportStatus? status,
  });
}
