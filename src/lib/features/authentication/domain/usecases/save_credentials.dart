import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';

class SaveCredentialsUseCase implements Usecase<void, SaveCredentialsParams> {
  final AuthRepository repository;

  SaveCredentialsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveCredentialsParams params) {
    return repository.saveCredentials(
      email: params.email,
      password: params.password,
    );
  }
}

class SaveCredentialsParams {
  final String email;
  final String password;

  SaveCredentialsParams({
    required this.email,
    required this.password,
  });
}
