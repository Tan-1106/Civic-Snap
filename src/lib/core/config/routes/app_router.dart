import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/common/layouts/admin_shell_layout.dart';
import 'package:src/core/common/layouts/user_shell_layout.dart';
import 'package:src/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:src/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:src/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:src/features/map/presentation/pages/map_screen.dart';
import 'package:src/features/report/presentation/pages/send_report_page.dart';

// GoRouter Navigator Keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _adminShellNavigatorKey = GlobalKey<NavigatorState>();
final _userShellNavigatorKey = GlobalKey<NavigatorState>();

// App Router
final GoRouter appRouter = GoRouter(
  initialLocation: '/sign-in',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // Public Routes
    GoRoute(
      name: 'signIn',
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      name: 'signUp',
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: 'forgotPassword',
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // Admin Shell Route
    ShellRoute(
      navigatorKey: _adminShellNavigatorKey,
      builder: (context, state, child) {
        return AdminShellLayout(child: child);
      },
      routes: [
        GoRoute(
          name: 'adminDashboard',
          path: '/admin-dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          name: 'adminMap',
          path: '/admin-map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          name: 'adminUserManagement',
          path: '/admin-user-management',
          builder: (context, state) => const Scaffold(body: Center(child: Text('User Management'))),
        ),
      ],
    ),

    // User Shell Route
    ShellRoute(
      navigatorKey: _userShellNavigatorKey,
      builder: (context, state, child) {
        return UserShellLayout(child: child);
      },
      routes: [
        GoRoute(
          name: 'userMap',
          path: '/user-map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          name: 'userReport',
          path: '/user-report',
          builder: (context, state) => const SendReportPage(),
        ),
        GoRoute(
          name: 'userProfile',
          path: '/user-profile',
          builder: (context, state) => const Scaffold(body: Center(child: Text('User Profile'))),
        ),
      ],
    ),
  ],
);
