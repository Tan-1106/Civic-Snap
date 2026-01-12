import 'package:flutter/material.dart';
import 'package:src/core/utils/usecase.dart';
import 'package:src/features/authentication/domain/entities/user_entity.dart';
import 'package:src/features/authentication/domain/usecases/forgot_password.dart';
import 'package:src/features/authentication/domain/usecases/save_credentials.dart';
import 'package:src/features/authentication/domain/usecases/clear_credentials.dart';
import 'package:src/features/authentication/domain/usecases/sign_up_with_email.dart';
import 'package:src/features/authentication/domain/usecases/sign_in_with_email.dart';
import 'package:src/features/authentication/domain/usecases/get_route_for_role.dart';
import 'package:src/features/authentication/domain/usecases/get_saved_credentials.dart';

class AuthenticationProvider extends ChangeNotifier {
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SaveCredentialsUseCase _saveCredentialsUseCase;
  final GetSavedCredentialsUseCase _getSavedCredentialsUseCase;
  final ClearCredentialsUseCase _clearCredentialsUseCase;
  final GetRouteForRoleUseCase _getRouteForRoleUseCase;

  AuthenticationProvider(
    SignUpWithEmailUseCase signUpWithEmailUseCase,
    SignInWithEmailUseCase signInWithEmailUseCase,
    ForgotPasswordUseCase forgotPasswordUseCase,
    SaveCredentialsUseCase saveCredentialsUseCase,
    GetSavedCredentialsUseCase getSavedCredentialsUseCase,
    ClearCredentialsUseCase clearCredentialsUseCase,
    GetRouteForRoleUseCase getRouteForRoleUseCase,
  ) : _signUpWithEmailUseCase = signUpWithEmailUseCase,
      _signInWithEmailUseCase = signInWithEmailUseCase,
      _forgotPasswordUseCase = forgotPasswordUseCase,
      _saveCredentialsUseCase = saveCredentialsUseCase,
      _getSavedCredentialsUseCase = getSavedCredentialsUseCase,
      _clearCredentialsUseCase = clearCredentialsUseCase,
      _getRouteForRoleUseCase = getRouteForRoleUseCase;

  // States
  UserEntity? _user;

  UserEntity? get user => _user;

  String get userId => _user?.id ?? '';

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _redirectRoute;

  String? get redirectRoute => _redirectRoute;

  Map<String, String?>? _savedCredentials;

  Map<String, String?>? get savedCredentials => _savedCredentials;

  // Sign Up with Email
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _signUpWithEmailUseCase(
      SignUpWithEmailParams(
        name: name,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (user) {
        _user = user;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // Sign In with Email
  Future<void> signInWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _signInWithEmailUseCase(
      SignInWithEmailParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (user) async {
        _user = user;
        _errorMessage = null;

        if (rememberMe) {
          await saveCredentials(email: email, password: password);
        }
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // Forgot Password
  Future<void> forgotPassword({
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(
        email: email,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    final result = await _saveCredentialsUseCase(
      SaveCredentialsParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {
        _savedCredentials = {
          'email': email,
          'password': password,
        };
      },
    );
  }

  // Load saved credentials
  Future<void> loadSavedCredentials() async {
    final result = await _getSavedCredentialsUseCase(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _savedCredentials = null;
      },
      (credentials) {
        _savedCredentials = credentials;
      },
    );

    notifyListeners();
  }

  // Clear saved credentials
  Future<void> clearCredentials() async {
    final result = await _clearCredentialsUseCase(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {
        _savedCredentials = null;
      },
    );

    notifyListeners();
  }

  Future<String?> getRouteForRole() async {
    if (_user == null) {
      _errorMessage = 'User not authenticated';
      return null;
    }

    final result = await _getRouteForRoleUseCase(
      GetRouteForRoleParams(user: _user!),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return null;
      },
      (route) {
        _redirectRoute = route;
        notifyListeners();
        return route;
      },
    );
  }

  // Clear redirect route
  void clearRedirectRoute() {
    _redirectRoute = null;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
