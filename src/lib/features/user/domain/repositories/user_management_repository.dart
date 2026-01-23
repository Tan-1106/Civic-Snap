import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user.dart';
import 'package:src/features/user/domain/entities/user_report.dart';

abstract interface class UserManagementRepository {
  // Fetch users with optional keyword search and pagination
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  });

  // Fetch user reports with optional status filter and pagination
  Future<Either<Failure, List<UserReportEntity>>> getUserReports({
    required int limit,
    required String userId,
    ReportStatus? status,
    String? lastReportId,
  });

  // Get user profile by user ID
  Future<Either<Failure, UserEntity>> getUserProfile(String userId);

  // Update basic information of a report
  Future<Either<Failure, void>> updateReportBasicInformation({
    required String reportId,
    String? title,
    String? description,
  });

  // Delete a report by its ID
  Future<Either<Failure, void>> deleteReport({
    required String reportId,
  });

  // Update user profile image
  Future<Either<Failure, void>> updateProfileImage({
    required String userId,
    required File image,
  });
}
