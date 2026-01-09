import 'package:fpdart/fpdart.dart';
import 'package:src/core/common/enums/user_role.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/entities/user_entity.dart';

class GetRouteForRoleUseCase implements UseCase<String, GetRouteForRoleParams> {
  @override
  Future<Either<Failure, String>> call(GetRouteForRoleParams params) async {
    try {
      final role = UserRole.fromString(params.user.role);
      return Right(role.initialRoute);
    } catch (e) {
      return Left(Failure('Failed to determine user role'));
    }
  }
}

class GetRouteForRoleParams {
  final UserEntity user;

  const GetRouteForRoleParams({required this.user});
}

