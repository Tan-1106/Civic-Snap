import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/usecases/get_reports.dart';
import 'package:src/features/dashboard/domain/usecases/respond_to_report.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report.dart';

class DashboardProvider extends ChangeNotifier {
  final GetReportsUseCase _getReportsUseCase;
  final RespondToReportUseCase _respondToReportUseCase;

  DashboardProvider(
    GetReportsUseCase getReportsUseCase,
    RespondToReportUseCase respondToReportUseCase,
  ) : _getReportsUseCase = getReportsUseCase,
      _respondToReportUseCase = respondToReportUseCase;

  // States
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DashboardReportEntity> _reports = [];

  List<DashboardReportEntity> get reports => _reports;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  String? _lastReportId;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  static const int _pageSize = 10;

  ReportStatus? _currentFilterStatus;

  ReportStatus? get currentFilterStatus => _currentFilterStatus;

  String? _currentFilterUserId;

  String? get currentFilterUserId => _currentFilterUserId;

  /// Fetch initial reports (refresh)
  Future<void> getReports({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _reports = [];
      _lastReportId = null;
      _hasMore = true;
      _errorMessage = null;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _getReportsUseCase.call(
      GetReportsParams(
        limit: _pageSize,
        status: _currentFilterStatus,
        userId: _currentFilterUserId,
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

  /// Load more reports for infinite scroll
  Future<void> loadMoreReports() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    final result = await _getReportsUseCase.call(
      GetReportsParams(
        limit: _pageSize,
        status: _currentFilterStatus,
        userId: _currentFilterUserId,
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

  // Respond to report
  Future<bool> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  }) async {
    final result = await _respondToReportUseCase.call(
      RespondToReportParams(
        reportId: reportId,
        newStatus: newStatus,
        response: response,
      ),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (success) => true,
    );
  }

  // Set filter status
  void setFilterStatus(ReportStatus? status) {
    _currentFilterStatus = status;
    notifyListeners();
  }

  // Set filter user ID
  void setFilterUserId(String? userId) {
    _currentFilterUserId = userId;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _reports = [];
    _errorMessage = null;
    _isLoading = false;
    _isLoadingMore = false;
    _hasMore = true;
    _lastReportId = null;
    notifyListeners();
  }
}
