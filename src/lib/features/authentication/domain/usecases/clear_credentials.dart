import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';

class ClearCredentialsUseCase implements Usecase<void, NoParams> {
  final AuthRepository repository;

  ClearCredentialsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearSavedCredentials();
  }
}
