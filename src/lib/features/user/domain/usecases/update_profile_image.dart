import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class UpdateProfileImageUseCase implements UseCase<bool, UpdateProfileImageParams> {
  final UserManagementRepository repository;

  UpdateProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileImageParams params) {
    return repository.updateProfileImage(
      userId: params.userId,
      image: params.image,
    );
  }
}

class UpdateProfileImageParams {
  final String userId;
  final File image;

  UpdateProfileImageParams({
    required this.userId,
    required this.image,
  });
}

