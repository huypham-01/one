import '../../domain/entities/dashboard_report_entity.dart';

class DashboardReportModel {
  final int total;
  final int onWait;
  final int todayTotal;
  final int todayFixed;
  final List<CategoryBreakdownModel> categoryBreakdown;
  final List<TrendModel> trend7d;

  DashboardReportModel({
    required this.total,
    required this.onWait,
    required this.todayTotal,
    required this.todayFixed,
    required this.categoryBreakdown,
    required this.trend7d,
  });

  factory DashboardReportModel.fromJson(Map<String, dynamic> json) {
    return DashboardReportModel(
      total: json['total'] as int? ?? 0,
      onWait: json['on_wait'] as int? ?? 0,
      todayTotal: json['today_total'] as int? ?? 0,
      todayFixed: json['today_fixed'] as int? ?? 0,
      categoryBreakdown: (json['category_breakdown'] as List<dynamic>?)
              ?.map((e) =>
                  CategoryBreakdownModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trend7d: (json['trend_7d'] as List<dynamic>?)
              ?.map((e) => TrendModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  DashboardReportEntity toEntity() {
    return DashboardReportEntity(
      total: total,
      onWait: onWait,
      todayTotal: todayTotal,
      todayFixed: todayFixed,
      categoryBreakdown: categoryBreakdown.map((e) => e.toEntity()).toList(),
      trend7d: trend7d.map((e) => e.toEntity()).toList(),
    );
  }
}

class CategoryBreakdownModel {
  final String category;
  final int count;

  CategoryBreakdownModel({
    required this.category,
    required this.count,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      category: json['category'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  CategoryBreakdownEntity toEntity() {
    return CategoryBreakdownEntity(
      category: category,
      count: count,
    );
  }
}

class TrendModel {
  final String date;
  final int count;

  TrendModel({
    required this.date,
    required this.count,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) {
    return TrendModel(
      date: json['date'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  TrendEntity toEntity() {
    return TrendEntity(
      date: date,
      count: count,
    );
  }
}
