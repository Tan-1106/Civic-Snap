import 'package:src/core/services/secure_storage_service.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  Future<Map<String, String?>> getCredentials();

  Future<void> clearCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  const AuthLocalDataSourceImpl(this._secureStorageService);

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _secureStorageService.saveCredentials(email, password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    final email = await _secureStorageService.getEmail();
    final password = await _secureStorageService.getPassword();

    return {
      'email': email,
      'password': password,
    };
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorageService.clearCredentials();
  }
}
