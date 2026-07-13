class DashboardReportEntity {
  final int total;
  final int onWait;
  final int todayTotal;
  final int todayFixed;
  final List<CategoryBreakdownEntity> categoryBreakdown;
  final List<TrendEntity> trend7d;

  const DashboardReportEntity({
    required this.total,
    required this.onWait,
    required this.todayTotal,
    required this.todayFixed,
    required this.categoryBreakdown,
    required this.trend7d,
  });
}

class CategoryBreakdownEntity {
  final String category;
  final int count;

  const CategoryBreakdownEntity({
    required this.category,
    required this.count,
  });
}

class TrendEntity {
  final String date;
  final int count;

  const TrendEntity({
    required this.date,
    required this.count,
  });
}
