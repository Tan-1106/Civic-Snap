import 'package:src/core/services/secure_storage_service.dart';

abstract interface class AuthLocalDataSource {
  // Save user credentials
  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  // Get user credentials
  Future<Map<String, String?>> getCredentials();

  // Clear user credentials
  Future<void> clearCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  const AuthLocalDataSourceImpl(this._secureStorageService);

  // Save user credentials
  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _secureStorageService.saveCredentials(email, password);
  }

  // Get user credentials
  @override
  Future<Map<String, String?>> getCredentials() async {
    final email = await _secureStorageService.getEmail();
    final password = await _secureStorageService.getPassword();

    return {
      'email': email,
      'password': password,
    };
  }

  // Clear user credentials
  @override
  Future<void> clearCredentials() async {
    await _secureStorageService.clearCredentials();
  }
}
