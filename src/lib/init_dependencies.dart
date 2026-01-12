// Dependency Injection Setup using GetIt
import 'package:get_it/get_it.dart';
import 'package:src/core/network/connection_checker.dart';
import 'package:src/core/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:src/features/user/data/datasources/user_remote_data_source.dart';
import 'package:src/features/user/data/repositories/user_management_repository_impl.dart';
import 'package:src/features/user/domain/repositories/user_management_repository.dart';
import 'package:src/features/user/domain/usecases/get_user_profile.dart';
import 'package:src/features/user/domain/usecases/get_user_reports.dart';
import 'package:src/features/user/domain/usecases/get_users.dart';
import 'package:src/features/user/domain/usecases/update_report_basic_information.dart';
import 'package:src/features/user/domain/usecases/update_profile_image.dart';
import 'package:src/features/user/domain/usecases/delete_report.dart';
import 'package:src/features/user/presentation/providers/user_management_provider.dart';
import 'package:src/features/user/presentation/providers/user_profile_provider.dart';

// Firebase imports
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Dashboard feature imports
import 'package:src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:src/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:src/features/dashboard/domain/usecases/get_reports.dart';
import 'package:src/features/dashboard/domain/usecases/respond_to_report.dart';
import 'package:src/features/dashboard/presentation/providers/dashboard_provider.dart';

// Report feature imports
import 'package:src/features/report/data/datasources/report_remote_data_source.dart';
import 'package:src/features/report/data/repositories/report_repository_impl.dart';
import 'package:src/features/report/domain/repositories/report_repository.dart';
import 'package:src/features/report/domain/usecases/submit_report.dart';
import 'package:src/features/report/domain/usecases/upload_image.dart';
import 'package:src/features/report/presentation/providers/report_provider.dart';

// Authentication feature imports
import 'package:src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:src/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:src/features/authentication/domain/usecases/sign_up_with_email.dart';
import 'package:src/features/authentication/domain/usecases/sign_in_with_email.dart';
import 'package:src/features/authentication/domain/usecases/forgot_password.dart';
import 'package:src/features/authentication/domain/usecases/save_credentials.dart';
import 'package:src/features/authentication/domain/usecases/get_saved_credentials.dart';
import 'package:src/features/authentication/domain/usecases/clear_credentials.dart';
import 'package:src/features/authentication/domain/usecases/get_route_for_role.dart';
import 'package:src/features/authentication/presentation/providers/authentication_provider.dart';

// Map feature imports
import 'package:src/features/map/data/datasources/map_remote_data_source.dart';
import 'package:src/features/map/data/repositories/map_repository_impl.dart';
import 'package:src/features/map/domain/repositories/map_repository.dart';
import 'package:src/features/map/domain/usecases/get_map_reports.dart';
import 'package:src/features/map/presentation/providers/map_provider.dart';

part 'init_dependencies.main.dart';