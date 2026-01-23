import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/user/domain/entities/user.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class GetUserProfileUseCase implements UseCase<UserEntity, GetUserProfileParams> {
  final UserManagementRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetUserProfileParams params) {
    return repository.getUserProfile(params.userId);
  }
}

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({
    required this.userId,
  });
}

