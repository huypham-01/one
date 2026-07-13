import 'package:flutter/material.dart';
import 'package:mobile/cmms/presentation/main_navigation.dart';
import 'package:mobile/cmms/presentation/screens/equipment/equipment_detail_scan.dart';
import 'package:mobile/cmms/presentation/screens/equipment/equipment_screen.dart';
import 'package:mobile/cmms/presentation/screens/home/work_schedula.dart';
import 'package:mobile/cmms/presentation/screens/task/maintenance_screen.dart';
import 'package:mobile/cmms/presentation/screens/task/overdue_screen.dart';
import 'package:mobile/cmms/presentation/screens/task/task_screen.dart';
import 'package:mobile/cmms/presentation/screens/scan/qr_scan_screen.dart';
import 'package:mobile/cmms/presentation/screens/report/submit_repair_result_screen.dart';
import 'package:mobile/cmms/presentation/screens/report/waiting_repair_screen.dart';
import 'package:mobile/cmms/presentation/screens/report/reported_today_screen.dart';
import 'package:mobile/cmms/presentation/screens/report/fixed_today_screen.dart';
import 'package:mobile/cmms/presentation/screens/report/total_history_screen.dart';

import '../../cmms/presentation/screens/report/breakdown_history_screen.dart';

class CmmsRoutes {
  // static const login = '/cmms/login';
  static const main = '/cmms/main';
  static const todayTasks = '/cmms/today_tasks';
  static const maintenanceTasks = '/cmms/maintenance_tasks';
  static const equipment = '/cmms/equipment';
  static const workschedule = '/cmms/workschedule';
  static const qrscan = '/cmms/qrscan';
  static const qrscanDetail = '/cmms/qrscan_detail';
  static const overdue = '/cmms/overdue';
  static const submitRepairResult = '/cmms/submit_repair_result';

  // Dashboard card routes
  static const waitingRepairTemplate = '/cmms/waiting_repair_template';
  static const reportedTodayTemplate = '/cmms/reported_today_template';
  static const fixedTodayTemplate = '/cmms/fixed_today_template';
  static const totalHistoryTemplate = '/cmms/total_history_template';
  static const breakHistory = '/cmms/breakdown_history';

  /// ✅ Thay vì Map, ta viết 1 hàm nhận RouteSettings
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case login:
      //   return MaterialPageRoute(builder: (_) => LoginScreen(keyWork: "cmms",));
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case overdue:
        return MaterialPageRoute(builder: (_) => const OverdueScreen());
      case todayTasks:
        return MaterialPageRoute(builder: (_) => TasksScreen());
      case maintenanceTasks:
        return MaterialPageRoute(builder: (_) => MaintenanceScreen());
      case equipment:
        return MaterialPageRoute(builder: (_) => EquipmentScreen());
      case workschedule:
        return MaterialPageRoute(builder: (_) => WorkSchedulePage());
      case qrscanDetail:
        final uuid = settings.arguments as String?; // ✅ Nhận tham số
        return MaterialPageRoute(
          builder: (_) => EquipmentDetailScreen(uuid: uuid),
        );
      case qrscan:
        return MaterialPageRoute(builder: (_) => const QrScanScreen());
      case submitRepairResult:
        final scanResult = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => SubmitRepairResultScreen(scanResult: scanResult),
        );
      case waitingRepairTemplate:
        return MaterialPageRoute(builder: (_) => const WaitingRepairScreen());
      case reportedTodayTemplate:
        return MaterialPageRoute(builder: (_) => const ReportedTodayScreen());
      case fixedTodayTemplate:
        return MaterialPageRoute(builder: (_) => const FixedTodayScreen());
      case totalHistoryTemplate:
        return MaterialPageRoute(builder: (_) => const TotalHistoryScreen());
      case breakHistory:
        return MaterialPageRoute(
          builder: (_) => const BreakdownHistoryScreen(),
        );
      default:
        return null; // Cho AppRoutes xử lý tiếp
    }
  }
}
