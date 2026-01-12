import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/domain/entities/user_entity.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';
import 'package:src/features/user/domain/usecases/delete_report.dart';
import 'package:src/features/user/domain/usecases/get_user_profile.dart';
import 'package:src/features/user/domain/usecases/get_user_reports.dart';
import 'package:src/features/user/domain/usecases/update_report_basic_information.dart';

class UserProfileProvider extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetUserReportsUseCase _getUserReportsUseCase;
  final UpdateReportBasicInformationUseCase _updateReportBasicInformationUseCase;
  final DeleteReportUseCase _deleteReportUseCase;

  UserProfileProvider(
    GetUserProfileUseCase getUserProfileUseCase,
    GetUserReportsUseCase getUserReportsUseCase,
    UpdateReportBasicInformationUseCase updateReportBasicInformationUseCase,
    DeleteReportUseCase deleteReportUseCase,
  ) : _getUserProfileUseCase = getUserProfileUseCase,
      _getUserReportsUseCase = getUserReportsUseCase,
      _updateReportBasicInformationUseCase = updateReportBasicInformationUseCase,
      _deleteReportUseCase = deleteReportUseCase;

  // States
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingProfile = false;

  bool get isLoadingProfile => _isLoadingProfile;

  static const int _pageSize = 10;

  // User Profile
  String? _userId;

  String? get userId => _userId;

  UserEntity? _userProfile;

  UserEntity? get userProfile => _userProfile;

  Future<void> fetchUserProfile() async {
    _isLoadingProfile = true;
    notifyListeners();

    final result = await _getUserProfileUseCase(
      GetUserProfileParams(
        userId: _userId!,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (profile) {
        _userProfile = profile;
        _errorMessage = null;
      },
    );

    _isLoadingProfile = false;
    notifyListeners();
  }

  // Get user reports
  List<UserReportEntity> _reports = [];

  List<UserReportEntity> get userReports => _reports;

  bool _hasMore = true;

  bool get hasMoreReports => _hasMore;

  String? _lastReportId;

  bool _isLoadingMore = false;

  bool get isLoadingMoreReports => _isLoadingMore;

  ReportStatus? _currentReportStatusFilter;

  ReportStatus? get currentReportStatusFilter => _currentReportStatusFilter;

  Future<void> getUserReports({
    bool refresh = false,
  }) async {
    if (_isLoading) {
      return;
    }

    if (refresh) {
      _reports = [];
      _lastReportId = null;
      _hasMore = true;
      _errorMessage = null;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _getUserReportsUseCase.call(
      GetUserReportsParams(
        limit: _pageSize,
        userId: _userId!,
        status: _currentReportStatusFilter,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _reports = data;
        _hasMore = data.length >= _pageSize;
        _lastReportId = data.isNotEmpty ? data.last.id : null;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUserReports() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final result = await _getUserReportsUseCase.call(
      GetUserReportsParams(
        limit: _pageSize,
        userId: _userId!,
        status: _currentReportStatusFilter,
        lastReportId: _lastReportId,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _reports = [..._reports, ...data];
        _hasMore = data.length >= _pageSize;
        _lastReportId = data.isNotEmpty ? data.last.id : _lastReportId;
        _errorMessage = null;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  // Update Report
  Future<void> updateReportBasicInformation({
    required String reportId,
    String? title,
    String? description,
  }) async {
    _isLoadingMore = true;
    notifyListeners();

    final result = await _updateReportBasicInformationUseCase.call(
      UpdateReportBasicInformationParams(
        reportId: reportId,
        title: title,
        description: description,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (success) {
        _errorMessage = null;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  // Delete Report
  Future<void> deleteReport({required String reportId}) async {
    try {
      _isLoadingMore = true;
      notifyListeners();

      final result = await _deleteReportUseCase.call(
        DeleteReportParams(reportId: reportId),
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (success) {
          _reports.removeWhere((report) => report.id == reportId);
          _errorMessage = null;
        },
      );

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // Set State
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void setReportStatusFilter(ReportStatus? status) {
    _currentReportStatusFilter = status;
    notifyListeners();
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset provider state
  void reset() {
    _userId = null;
    _userProfile = null;
    _reports = [];
    _hasMore = true;
    _lastReportId = null;
    _currentReportStatusFilter = null;
    _errorMessage = null;
    _isLoading = false;
    _isLoadingProfile = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
