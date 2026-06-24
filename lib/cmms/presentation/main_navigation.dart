import 'package:flutter/material.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';

import '../../utils/constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/report/report_screen.dart';
import 'screens/settings/setting_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkingInstructionsScreen(),
    const ReportScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appBarTitle = _selectedIndex == 0
        ? localizations.cmms
        : _selectedIndex == 1
        ? localizations.listInstructions
        : _selectedIndex == 2
        ? 'Report'
        : localizations.profile;

    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Nền sáng sủa, sạch sẽ cho app công nghiệp
      appBar: _selectedIndex == 4
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                appBarTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset('assets/images/acumenIcon.png'),
              ),
              leadingWidth: 54, // Độ rộng hợp lý cho logo
              actions: [
                if (_selectedIndex == 2)
                  IconButton(
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.black54,
                      size: 26,
                    ),
                    onPressed: () {
                      // TODO: Xử lý sự kiện quét QR/Barcode tại đây
                    },
                    tooltip: 'Quét mã',
                  ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(color: Colors.grey[300], height: 1.0),
              ),
            ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          indicatorColor: cusBlue.withOpacity(0.15),
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: cusBlue),
              label: localizations.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.checklist_rtl_outlined),
              selectedIcon: Icon(Icons.checklist, color: cusBlue),
              label: localizations.instructions,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.bar_chart_outlined,
              ), // Icon rõ ràng hơn cho report
              selectedIcon: Icon(Icons.bar_chart, color: cusBlue),
              label: 'Report',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: cusBlue),
              label: localizations.profile,
            ),
          ],
        ),
      ),
    );
  }
}
