import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/features/authentication/domain/entities/user.dart';

abstract interface class AuthRepository {
  // Sign up with email and password
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  // Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  // Forgot password
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  // Save credentials locally
  Future<Either<Failure, void>> saveCredentials({
    required String email,
    required String password,
  });

  // Get saved credentials
  Future<Either<Failure, Map<String, String?>>> getSavedCredentials();

  // Clear saved credentials
  Future<Either<Failure, void>> clearSavedCredentials();
}
