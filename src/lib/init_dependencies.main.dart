part of 'init_dependencies.dart';

// Initialize Dependencies
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  _initAuth();
}

// Initialize Core Module
Future<void> _initCore() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseStorage.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Internet Connection Checker
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  // Secure Storage Service
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());
  serviceLocator.registerLazySingleton(
    () => SecureStorageService(
      serviceLocator(),
    ),
  );
}

// Initialize Authentication Module
void _initAuth() {
  // Data Sources
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator<FirebaseAuth>(),
      serviceLocator<FirebaseFirestore>(),
    ),
  );

  serviceLocator.registerFactory<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      serviceLocator<SecureStorageService>(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator<AuthRemoteDataSource>(),
      serviceLocator<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => SignUpWithEmailUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SignInWithEmailUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ForgotPasswordUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SaveCredentialsUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetSavedCredentialsUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ClearCredentialsUseCase(
      serviceLocator(),
    ),
  );

  // Provider
  serviceLocator.registerLazySingleton(
    () => AuthenticationProvider(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
}
