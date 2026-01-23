import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user.dart';
import 'package:src/features/user/domain/entities/user_report.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';
import 'package:src/features/user/data/datasources/user_remote_data_source.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  UserRemoteDataSource remoteDataSource;

  UserManagementRepositoryImpl(
    this.remoteDataSource,
  );

  // Fetch users with optional keyword search and pagination
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

  // Fetch user reports with optional status filter and pagination
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

  // Get user profile by user ID
  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return right(user.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update report basic information
  @override
  Future<Either<Failure, void>> updateReportBasicInformation({
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

  // Delete a report by its ID
  @override
  Future<Either<Failure, void>> deleteReport({
    required String reportId,
  }) async {
    try {
      final result = await remoteDataSource.deleteReport(reportId: reportId);
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update user profile image
  @override
  Future<Either<Failure, void>> updateProfileImage({
    required String userId,
    required File image,
  }) async {
    try {
      final result = await remoteDataSource.uploadProfileImage(
        userId: userId,
        image: image,
      );
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}