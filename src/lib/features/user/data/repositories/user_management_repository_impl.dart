import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user_entity.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';
import 'package:src/features/user/data/datasources/user_remote_data_source.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  UserRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  }) async {
    try {
      final users = await remoteDataSource.getUsers(
        limit: limit,
        keyword: keyword,
        lastUserId: lastUserId,
      );
      return right(users.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserReportEntity>>> getUserReports({
    required int limit,
    required String userId,
    ReportStatus? status,
    String? lastReportId,
  }) async {
    try {
      final reports = await remoteDataSource.getUserReports(
        limit: limit,
        userId: userId,
        status: status,
        lastReportId: lastReportId,
      );
      return right(reports.map((e) => e.toEntity()).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return right(user.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateReportBasicInformation({
    required String reportId,
    String? title,
    String? description,
  }) async {
    try {
      final result = await remoteDataSource.updateReportBasicInformation(
        reportId: reportId,
        title: title,
        description: description,
      );
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReport({
    required String reportId,
  }) async {
    try {
      final result = await remoteDataSource.deleteReport(reportId: reportId);
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}