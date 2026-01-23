import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:src/features/authentication/domain/entities/user.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:src/features/authentication/data/datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  // Sign up with email and password
  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      return right(userModel.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Sign in with email and password
  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return right(userModel.toEntity());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Forgot password
  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await remoteDataSource.forgotPassword(
        email: email,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Save credentials locally
  @override
  Future<Either<Failure, void>> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await localDataSource.saveCredentials(
        email: email,
        password: password,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Get saved credentials
  @override
  Future<Either<Failure, Map<String, String?>>> getSavedCredentials() async {
    try {
      final credentials = await localDataSource.getCredentials();
      return right(credentials);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Clear saved credentials
  @override
  Future<Either<Failure, void>> clearSavedCredentials() async {
    try {
      await localDataSource.clearCredentials();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
