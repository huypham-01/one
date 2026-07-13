import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_report_entity.dart';
import '../../domain/usecases/get_dashboard_report_usecase.dart';

enum DashboardReportState { initial, loading, loaded, error }

class DashboardReportProvider extends ChangeNotifier {
  final GetDashboardReportUseCase _getDashboardReportUseCase;

  DashboardReportState _state = DashboardReportState.initial;
  DashboardReportEntity? _dashboard;
  String _errorMessage = '';

  DashboardReportProvider(this._getDashboardReportUseCase) {
    loadDashboardReport();
  }

  DashboardReportState get state => _state;
  DashboardReportEntity? get dashboard => _dashboard;
  String get errorMessage => _errorMessage;

  Future<void> loadDashboardReport() async {
    _state = DashboardReportState.loading;
    notifyListeners();

    try {
      final dashboard = await _getDashboardReportUseCase();
      _dashboard = dashboard;
      _state = DashboardReportState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = DashboardReportState.error;
    }

    notifyListeners();
  }
}
