import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/entities/user.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';

class SignUpWithEmailUseCase implements UseCase<UserEntity, SignUpWithEmailParams> {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithEmailParams params) {
    return repository.signUpWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpWithEmailParams {
  final String name;
  final String email;
  final String password;

  SignUpWithEmailParams({
    required this.name,
    required this.email,
    required this.password,
  });
}