import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/usecases/get_users.dart';
import 'package:src/features/user/domain/entities/user_entity.dart';
import 'package:src/features/user/domain/usecases/get_user_reports.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';

class UserManagementProvider extends ChangeNotifier {
  final GetUsersUseCase _getUsersUseCase;
  final GetUserReportsUseCase _getUserReportsUseCase;

  UserManagementProvider(
    GetUsersUseCase getUsersUseCase,
    GetUserReportsUseCase getUserReportsUseCase,
  ) : _getUsersUseCase = getUsersUseCase,
      _getUserReportsUseCase = getUserReportsUseCase;

  // States
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  static const int _pageSize = 10;

  // Users list states
  List<UserEntity> _users = [];

  List<UserEntity> get users => _users;

  bool _hasMoreUsers = true;

  bool get hasMoreUsers => _hasMoreUsers;

  String? _lastUserId;

  bool _isLoadingMoreUsers = false;

  bool get isLoadingMoreUsers => _isLoadingMoreUsers;

  // User reports list states
  List<UserReportEntity> _userReports = [];

  List<UserReportEntity> get userReports => _userReports;

  bool _hasMoreReports = true;

  bool get hasMoreReports => _hasMoreReports;

  String? _lastReportId;

  bool _isLoadingMoreReports = false;

  bool get isLoadingMoreReports => _isLoadingMoreReports;

  // Fetch users
  String? _currentKeyword;

  String? get currentKeyword => _currentKeyword;

  Future<void> getUsers({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _users = [];
      _lastUserId = null;
      _hasMoreUsers = true;
      _errorMessage = null;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _getUsersUseCase.call(
      GetUsersParams(
        limit: _pageSize,
        keyword: _currentKeyword,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _users = data;
        _hasMoreUsers = data.length >= _pageSize;
        _lastUserId = data.isNotEmpty ? data.last.id : null;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMoreUsers || !_hasMoreUsers) return;

    _isLoadingMoreUsers = true;
    notifyListeners();

    final result = await _getUsersUseCase.call(
      GetUsersParams(
        limit: _pageSize,
        keyword: _currentKeyword,
        lastUserId: _lastUserId,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _users = [..._users, ...data];
        _hasMoreUsers = data.length >= _pageSize;
        _lastUserId = data.isNotEmpty ? data.last.id : _lastUserId;
        _errorMessage = null;
      },
    );

    _isLoadingMoreUsers = false;
    notifyListeners();
  }

  // Fetch user reports
  ReportStatus? _currentReportStatusFilter;

  ReportStatus? get currentReportStatusFilter => _currentReportStatusFilter;

  Future<void> getUserReports({
    required String userId,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _userReports = [];
      _lastReportId = null;
      _hasMoreReports = true;
      _errorMessage = null;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _getUserReportsUseCase.call(
      GetUserReportsParams(
        limit: _pageSize,
        userId: userId,
        status: _currentReportStatusFilter,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _userReports = data;
        _hasMoreReports = data.length >= _pageSize;
        _lastReportId = data.isNotEmpty ? data.last.id : null;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUserReports({required String userId}) async {
    if (_isLoadingMoreReports || !_hasMoreReports) return;

    _isLoadingMoreReports = true;
    notifyListeners();

    final result = await _getUserReportsUseCase.call(
      GetUserReportsParams(
        limit: _pageSize,
        userId: userId,
        status: _currentReportStatusFilter,
        lastReportId: _lastReportId,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _userReports = [..._userReports, ...data];
        _hasMoreReports = data.length >= _pageSize;
        _lastReportId = data.isNotEmpty ? data.last.id : _lastReportId;
        _errorMessage = null;
      },
    );

    _isLoadingMoreReports = false;
    notifyListeners();
  }

  // Setters for filters
  void setKeywordFilter(String? keyword) {
    _currentKeyword = keyword;
  }

  void setReportStatusFilter(ReportStatus? status) {
    _currentReportStatusFilter = status;
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset all states
  void reset() {
    _users = [];
    _userReports = [];
    _errorMessage = null;
    _isLoading = false;
    _hasMoreUsers = true;
    _lastUserId = null;
    _isLoadingMoreUsers = false;
    _hasMoreReports = true;
    _lastReportId = null;
    _isLoadingMoreReports = false;
    _currentKeyword = null;
    _currentReportStatusFilter = null;
    notifyListeners();
  }
}
