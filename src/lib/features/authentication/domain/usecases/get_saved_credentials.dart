import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';

class GetSavedCredentialsUseCase implements Usecase<Map<String, String?>, NoParams> {
  final AuthRepository repository;

  GetSavedCredentialsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, String?>>> call(NoParams params) {
    return repository.getSavedCredentials();
  }
}
