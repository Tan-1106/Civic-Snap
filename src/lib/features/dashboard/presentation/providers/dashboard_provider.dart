import 'package:flutter/material.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/domain/usecases/get_report_by_id.dart';
import 'package:src/features/dashboard/domain/usecases/get_reports.dart';
import 'package:src/features/dashboard/domain/usecases/get_reports_by_status.dart';
import 'package:src/features/dashboard/domain/usecases/get_reports_by_user.dart';

class DashboardProvider extends ChangeNotifier {
  final GetReportsUseCase _getReportsUseCase;
  final GetReportByIdUseCase _getReportByIdUseCase;
  final GetReportsByStatusUseCase _getReportsByStatusUseCase;
  final GetReportsByUserUseCase _getReportsByUserUseCase;

  DashboardProvider(
    GetReportsUseCase getReportsUseCase,
    GetReportByIdUseCase getReportByIdUseCase,
    GetReportsByStatusUseCase getReportsByStatusUseCase,
    GetReportsByUserUseCase getReportsByUserUseCase,
  ) : _getReportsUseCase = getReportsUseCase,
      _getReportByIdUseCase = getReportByIdUseCase,
      _getReportsByStatusUseCase = getReportsByStatusUseCase,
      _getReportsByUserUseCase = getReportsByUserUseCase;

  // State
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Pagination state
  List<DashboardReportEntity> _reports = [];

  List<DashboardReportEntity> get reports => _reports;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  String? _lastReportId;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  static const int _pageSize = 10;

  /// Fetch initial reports (refresh)
  Future<void> getReports({bool refresh = false}) async {
    debugPrint('DEBUG: getReports called, refresh: $refresh, isLoading: $_isLoading');
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
      GetReportsParams(limit: _pageSize),
    );

    result.fold(
      (failure) {
        debugPrint('DEBUG: getReports error: ${failure.message}');
        _errorMessage = failure.message;
      },
      (data) {
        debugPrint('DEBUG: getReports success: ${data.length} reports loaded');
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

  /// Get report by ID
  Future<DashboardReportEntity?> getReportById(String reportId) async {
    final result = await _getReportByIdUseCase.call(GetReportByIdParams(reportId: reportId));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return null;
      },
      (report) => report,
    );
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
