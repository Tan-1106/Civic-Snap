import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src/features/user/presentation/providers/user_management_provider.dart';
import 'package:src/init_dependencies.dart';
import 'package:src/core/utils/create_theme.dart';
import 'package:src/core/config/theme/theme.dart';
import 'package:src/core/config/routes/app_router.dart';
import 'package:src/features/report/presentation/providers/report_provider.dart';
import 'package:src/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:src/features/authentication/presentation/providers/authentication_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => serviceLocator<AuthenticationProvider>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<ReportProvider>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<DashboardProvider>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<UserManagementProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Noto Sans", "Basic");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Civic Snap',
      routerConfig: appRouter,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
