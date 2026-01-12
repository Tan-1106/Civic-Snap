import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/map/domain/usecases/get_map_reports.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';

class MapProvider extends ChangeNotifier {
  final GetMapReportsUseCase _getMapReports;

  MapProvider(GetMapReportsUseCase getMapReports) : _getMapReports = getMapReports;

  // States
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<MapReportEntity> _mapReports = [];

  List<MapReportEntity> get mapReports => _mapReports;

  // Get Map Reports
  int _limit = 20;

  int get limit => _limit;

  ReportStatus? _statusFilter;

  ReportStatus? get statusFilter => _statusFilter;

  Stream<List<MapReportEntity>> getMapReportsStream() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    return _getMapReports(
      GetMapReportsParams(
        limit: _limit,
        status: _statusFilter,
      ),
    ).map((result) {
      _isLoading = false;
      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _mapReports = [];
        },
        (reports) {
          _errorMessage = null;
          _mapReports = reports;
        },
      );
      notifyListeners();
      return _mapReports;
    });
  }

  void setLimit(int limit) {
    _limit = limit;
    notifyListeners();
  }

  void setStatusFilter(ReportStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }
}
