part of 'init_dependencies.dart';

// Initialize Dependencies
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  _initAuthentication();
  _initReport();
  _initDashboard();
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
void _initAuthentication() {
  // Data Sources
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      serviceLocator(),
    ),
  );

  // Repositories
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
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

  serviceLocator.registerFactory(
    () => GetRouteForRoleUseCase(),
  );

  // Providers
  serviceLocator.registerLazySingleton(
    () => AuthenticationProvider(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
}

// Initialize Report Module
void _initReport() {
  // Data Sources
  serviceLocator.registerFactory<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // Repositories
  serviceLocator.registerFactory<ReportRepository>(
    () => ReportRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => UploadImageUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SubmitReportUseCase(
      serviceLocator(),
    ),
  );

  // Providers
  serviceLocator.registerLazySingleton(
    () => ReportProvider(
      serviceLocator(),
      serviceLocator(),
    ),
  );
}

// Initialize Dashboard Module
void _initDashboard() {
  // Data Sources
  serviceLocator.registerFactory<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  // Repositories
  serviceLocator.registerFactory<DashboardRepository>(
    () => DashboardRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => GetReportsUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => GetReportByIdUseCase(
    serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => GetReportsByStatusUseCase(
    serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => GetReportsByUserUseCase(
    serviceLocator(),
    ),
  );

  // Providers
  serviceLocator.registerLazySingleton(
    () => DashboardProvider(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
}
