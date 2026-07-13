// lib/cmms/presentation/providers/waiting_repair_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/domain/usecases/get_on_wait_reports_usecase.dart';

enum WaitingRepairState { initial, loading, loaded, loadingMore, error }

class WaitingRepairProvider extends ChangeNotifier {
  final GetOnWaitReportsUseCase _useCase;

  static const int _pageSize = 10;

  WaitingRepairState _state = WaitingRepairState.initial;
  List<BreakdownReportModel> _items = [];
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;

  WaitingRepairProvider(this._useCase) {
    fetchReports();
  }

  // --- Getters ---
  WaitingRepairState get state => _state;
  List<BreakdownReportModel> get items => _items;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  bool get hasMore => _currentPage < _totalPages;
  bool get isLoadingMore => _state == WaitingRepairState.loadingMore;

  // --- Methods ---

  Future<void> fetchReports({bool reset = true}) async {
    if (reset) {
      _state = WaitingRepairState.loading;
      _currentPage = 1;
      _items = [];
      notifyListeners();
    }

    try {
      final result = await _useCase.execute(
        page: _currentPage,
        limit: _pageSize,
      );
      _items = [..._items, ...result.data];
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;
      _state = WaitingRepairState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = WaitingRepairState.error;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!hasMore || _state == WaitingRepairState.loadingMore) return;

    _state = WaitingRepairState.loadingMore;
    _currentPage++;
    notifyListeners();

    try {
      final result = await _useCase.execute(
        page: _currentPage,
        limit: _pageSize,
      );
      _items = [..._items, ...result.data];
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;
      _state = WaitingRepairState.loaded;
    } catch (e) {
      // Roll back page on error
      _currentPage--;
      _errorMessage = e.toString();
      _state = WaitingRepairState.loaded;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchReports(reset: true);
  }
}
