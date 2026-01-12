import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user_entity.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';

abstract interface class UserManagementRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  });

  Future<Either<Failure, List<UserReportEntity>>> getUserReports({
    required int limit,
    required String userId,
    ReportStatus? status,
    String? lastReportId,
  });
}
