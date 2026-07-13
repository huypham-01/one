// lib/cmms/presentation/providers/breakdown_history_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/domain/usecases/get_all_reports_usecase.dart';

enum BreakdownHistoryState { initial, loading, loaded, loadingMore, error }

class BreakdownHistoryProvider extends ChangeNotifier {
  final GetAllReportsUseCase _useCase;

  static const int _pageSize = 10;

  BreakdownHistoryState _state = BreakdownHistoryState.initial;
  List<BreakdownReportModel> _items = [];
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  String _searchQuery = '';
  Timer? _debounce;

  BreakdownHistoryProvider(this._useCase) {
    fetchReports();
  }

  // --- Getters ---
  BreakdownHistoryState get state => _state;
  List<BreakdownReportModel> get items => _items;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  String get searchQuery => _searchQuery;
  bool get hasMore => _currentPage < _totalPages;
  bool get isLoadingMore => _state == BreakdownHistoryState.loadingMore;

  // --- Methods ---

  Future<void> fetchReports({bool reset = true}) async {
    if (reset) {
      _state = BreakdownHistoryState.loading;
      _currentPage = 1;
      _items = [];
      notifyListeners();
    }

    try {
      final result = await _useCase.execute(
        page: _currentPage,
        limit: _pageSize,
        search: _searchQuery,
      );
      _items = [..._items, ...result.data];
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;
      _state = BreakdownHistoryState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = BreakdownHistoryState.error;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!hasMore || _state == BreakdownHistoryState.loadingMore) return;

    _state = BreakdownHistoryState.loadingMore;
    _currentPage++;
    notifyListeners();

    try {
      final result = await _useCase.execute(
        page: _currentPage,
        limit: _pageSize,
        search: _searchQuery,
      );
      _items = [..._items, ...result.data];
      _totalPages = result.totalPages;
      _totalItems = result.totalItems;
      _state = BreakdownHistoryState.loaded;
    } catch (e) {
      // Roll back page on error
      _currentPage--;
      _errorMessage = e.toString();
      _state = BreakdownHistoryState.loaded;
    }
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      fetchReports(reset: true);
    });
  }

  Future<void> refresh() async {
    _searchQuery = '';
    await fetchReports(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
