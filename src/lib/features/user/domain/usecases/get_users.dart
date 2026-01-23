import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/user/domain/entities/user.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, GetUsersParams> {
  final UserManagementRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(GetUsersParams params) {
    return repository.getUsers(
      limit: params.limit,
      keyword: params.keyword,
      lastUserId: params.lastUserId,
    );
  }
}

class GetUsersParams {
  final int limit;
  final String? keyword;
  final String? lastUserId;

  GetUsersParams({
    required this.limit,
    this.keyword,
    this.lastUserId,
  });
}

