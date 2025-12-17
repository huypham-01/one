import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/fmcs/screens/system_setting.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';
import 'package:mobile/main.dart';
import 'package:mobile/utils/routes/app_routes.dart';

import '../../utils/constants.dart';
import '../../utils/routes/fmcs_routes.dart';
import '../data/auth_api_service.dart';
import '../data/fmcs_api_service.dart';
import '../data/models/device_response_model.dart';
import 'widgets/create_action_dialog.dart';
import 'widgets/issues_dialog.dart';

class HomeFmcs extends StatefulWidget {
  const HomeFmcs({super.key});

  @override
  State<HomeFmcs> createState() => _HomeFmcsState();
}

class _HomeFmcsState extends State<HomeFmcs> {
  late FmcsApiService _apiService;
  List<DeviceItem> deviceDataList = [];
  List<SystemCategory> systemCategories = [];
  Map<String, int> statusSummary = {
    "total": 0,
    "connected": 0,
    "disconnected": 0,
    "breached": 0,
  };
  final List<String> systemOrder = [
    "Cooling Tower",
    "Chiller",
    "Vacuum Tank",
    "Air Dryer",
    "Compressor",
    "End Air Pressure",
    "Air Tank",
    "Air Conditioner",
    "Factory Temperature",
  ];

  String selectedCategory = 'issue';
  bool isCategoryExpanded = false;
  bool isLoading = false;
  bool isInitialLoad = true; // 👈 Thêm flag để phân biệt lần load đầu
  String? errorMessage;
  Timer? _refreshTimer;
  bool canApprove = false;
  bool canCreateAction = false;
  bool canActionView = false;

  @override
  void initState() {
    super.initState();
    _apiService = FmcsApiService();
    _loadData(showLoading: true); // 👈 Lần đầu hiển thị loading

    // Auto refresh mỗi 30 giây - không hiển thị loading
    _refreshTimer = Timer.periodic(const Duration(seconds: 55), (timer) {
      if (!isLoading) {
        _loadData(showLoading: false); // 👈 Refresh im lặng
      }
    });
    loadPermissions();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _apiService.dispose();
    super.dispose();
  }

  void loadPermissions() async {
    canApprove = await PermissionHelper.has("action.approve");
    canCreateAction = await PermissionHelper.has("action.create");
    canActionView = await PermissionHelper.has("action.view");
    setState(() {});
  }

  Future<void> _loadData({bool showLoading = false}) async {
    // Tránh gọi API nhiều lần đồng thời
    if (isLoading) {
      print('⚠️ Already loading, skip this call');
      return;
    }

    if (showLoading) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response = await _apiService.getAllDevicesDataWithAction();

      if (mounted) {
        setState(() {
          deviceDataList = response.allTableData;
          systemCategories = _buildSystemCategories(deviceDataList);
          statusSummary = _buildStatusSummary(response);
          isLoading = false;
          isInitialLoad = false;
        });

        print('✅ Data loaded: ${deviceDataList.length} devices');
      }
    } catch (e) {
      if (showLoading || isInitialLoad) {
        if (mounted) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });
          _showErrorDialog(e.toString());
        }
      } else {
        print('⚠️ Silent refresh failed: $e');
      }
    }
  }

  void onDataChanged() {
    print('loading');
    _loadData(); // Gọi lại API và update state
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.errorTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadData(showLoading: true); // 👈 Retry với loading
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  List<SystemCategory> _buildSystemCategories(List<DeviceItem> devices) {
    final Map<String, int> counts = {};
    for (var d in devices) {
      counts[d.system] = (counts[d.system] ?? 0) + 1;
    }

    // Sắp xếp theo thứ tự định nghĩa trong systemOrder
    List<SystemCategory> orderedCategories = [];
    for (var sys in systemOrder) {
      if (counts.containsKey(sys)) {
        orderedCategories.add(SystemCategory(name: sys, count: counts[sys]!));
      }
    }

    // Nếu có system nào ngoài danh sách systemOrder thì thêm cuối
    counts.forEach((key, value) {
      if (!systemOrder.contains(key)) {
        orderedCategories.add(SystemCategory(name: key, count: value));
      }
    });

    return orderedCategories;
  }

  int get issueCount {
    return deviceDataList
        .where(
          (device) =>
              device.status.toLowerCase() == 'red' ||
              device.status.toLowerCase() == 'brown_disconnect' ||
              device.connection.toLowerCase() == 'disconnected',
        )
        .length;
  }

  Map<String, int> _buildStatusSummary(DeviceResponseModel response) {
    return {
      "total": response.totalDevices,
      "connected": response.connectedDevices,
      "disconnected": response.disconnectedDevices,
      "breached": response.breachedDevices,
    };
  }

  List<DeviceItem> get filteredDeviceData {
    List<DeviceItem> devices;

    if (selectedCategory == 'issue') {
      devices = deviceDataList
          .where(
            (device) =>
                device.status.toLowerCase() == 'red' ||
                device.status.toLowerCase() == 'brown_disconnect' ||
                device.connection.toLowerCase() == 'disconnected',
          )
          .toList();

      // Sort riêng cho tab issue
      devices.sort((a, b) {
        // 1. Connected trước
        final aConnected = a.connection.toLowerCase() == 'connected' ? 0 : 1;
        final bConnected = b.connection.toLowerCase() == 'connected' ? 0 : 1;
        if (aConnected != bConnected) {
          return aConnected.compareTo(bConnected);
        }

        // 2. Nếu cùng connection, sort theo số lượng issues (nhiều trước)
        final aIssues = a.issues.length;
        final bIssues = b.issues.length;
        if (aIssues != bIssues) {
          return bIssues.compareTo(aIssues);
        }

        // 3. Nếu cùng số issues, sort theo deviceId
        return a.deviceId.compareTo(b.deviceId);
      });
    } else {
      devices = deviceDataList
          .where((device) => device.system == selectedCategory)
          .toList();

      // Giữ rule mặc định: Connected trước, sau đó deviceId
      devices.sort((a, b) {
        final aConnected = a.connection.toLowerCase() == 'connected' ? 0 : 1;
        final bConnected = b.connection.toLowerCase() == 'connected' ? 0 : 1;
        if (aConnected != bConnected) {
          return aConnected.compareTo(bConnected);
        }
        return a.deviceId.compareTo(b.deviceId);
      });
    }

    return devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset("assets/images/acumenIcon.png", height: 26),
            const SizedBox(width: 10),
            const Text(
              "FMCS",
              style: TextStyle(
                color: Color.fromARGB(221, 35, 34, 34),
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: "NotoSansSC",
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FutureBuilder<bool>(
              future: ApiServiceAuth.isLoggedIn(),
              builder: (context, snapshot) {
                final loggedIn = snapshot.data ?? false;

                return PopupMenuButton<String>(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: const Icon(
                    Icons.menu_sharp,
                    color: Colors.black87,
                    size: 30,
                  ),
                  onSelected: (value) async {
                    if (value == 'login') {
                      Navigator.pushNamed(context, FmcsRoutes.login);
                    } else if (value == 'logout') {
                      await ApiServiceAuth.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                        ),
                      );
                      setState(() {});
                    } else if (value == 'menu1') {
                      final loggedIn = await ApiServiceAuth.isLoggedIn();
                      if (loggedIn) {
                        final shouldReload = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SystemSetting(
                              devices: deviceDataList,
                              onDataChanged: onDataChanged,
                            ),
                          ),
                        );
                        if (shouldReload == true) {
                          _loadData(showLoading: true);
                        }
                      } else {
                        Navigator.pushNamed(context, FmcsRoutes.login);
                      }
                    } else if (value == 'menu2') {
                      final loggedIn = await ApiServiceAuth.isLoggedIn();
                      if (loggedIn) {
                        Navigator.pushNamed(
                          context,
                          FmcsRoutes.locationSetting,
                        );
                      } else {
                        Navigator.pushNamed(context, FmcsRoutes.login);
                      }
                    } else if (value == 'menu3') {
                      await ApiServiceAuth.logout();
                      Navigator.pushNamed(context, AppRoutes.home);
                    } else if (value == 'menu4') {
                      final loggedIn = await ApiServiceAuth.isLoggedIn();
                      if (loggedIn) {
                        Navigator.pushNamed(context, FmcsRoutes.approveAction);
                      } else {
                        Navigator.pushNamed(context, FmcsRoutes.login);
                      }
                    } else if (value == 'language') {
                      // Hiển thị menu phụ
                      await showMenu<String>(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 20, 0),
                        items: [
                          PopupMenuItem<String>(
                            enabled: false,
                            child: Text(
                              AppLocalizations.of(context)!.selectLanguage,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'lang_en',
                            child: Text('English'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'lang_vi',
                            child: Text('Tiếng Việt'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'lang_zh',
                            child: Text('中文（简体）'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'lang_tw',
                            child: Text('中文（繁體）'),
                          ),
                        ],
                        elevation: 8,
                      ).then((selected) {
                        if (selected == null) return;
                        if (selected == 'lang_en') {
                          MyApp.of(context)?.changeLanguage(const Locale('en'));
                        } else if (selected == 'lang_vi') {
                          MyApp.of(context)?.changeLanguage(const Locale('vi'));
                        } else if (selected == 'lang_zh') {
                          MyApp.of(context)?.changeLanguage(const Locale('zh'));
                        } else if (selected == 'lang_tw') {
                          MyApp.of(
                            context,
                          )?.changeLanguage(const Locale('zh', 'TW'));
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'menu1',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.settings,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(AppLocalizations.of(context)!.systemSettings),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'menu2',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.locationManagement,
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    if (canApprove) ...[
                      PopupMenuItem(
                        value: 'menu4',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(AppLocalizations.of(context)!.approvalStatus),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                    ],

                    // 🌐 Mục menu cấp 1
                    // PopupMenuItem(
                    //   value: 'language',
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.language,
                    //         color: Colors.blueGrey,
                    //         size: 20,
                    //       ),
                    //       SizedBox(width: 10),
                    //       Text(AppLocalizations.of(context)!.language),
                    //     ],
                    //   ),
                    // ),
                    // const PopupMenuDivider(),
                    PopupMenuItem(
                      value: loggedIn ? 'logout' : 'login',
                      child: Row(
                        children: [
                          Icon(
                            loggedIn ? Icons.logout : Icons.login,
                            color: loggedIn ? Colors.red : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            loggedIn
                                ? AppLocalizations.of(context)!.logout
                                : AppLocalizations.of(context)!.login,
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'menu3',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(AppLocalizations.of(context)!.back),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 6,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: _buildAllChips(small: true)
                            .map(
                              (chip) => SizedBox(
                                width: (constraints.maxWidth - 32) / 3,
                                child: chip,
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildAllChips(small: false)
                            .map(
                              (chip) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: chip,
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs Section
          Container(
            color: white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: isCategoryExpanded
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildTab(
                                    '${AppLocalizations.of(context)!.tabIssue} ($issueCount)',
                                    isSelected: selectedCategory == 'issue',
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = 'issue';
                                        isCategoryExpanded = false;
                                      });
                                    },
                                  ),
                                  ...systemCategories.map(
                                    (category) => _buildTab(
                                      '${_getSystemLabel(category.name)} (${category.count})',
                                      isSelected:
                                          selectedCategory == category.name,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category.name;
                                          isCategoryExpanded = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildTab(
                                      '${AppLocalizations.of(context)!.tabIssue} ($issueCount)',
                                      isSelected: selectedCategory == 'issue',
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = 'issue';
                                        });
                                      },
                                    ),
                                    ...systemCategories.map(
                                      (category) => _buildTab(
                                        '${_getSystemLabel(category.name)} (${category.count})',
                                        isSelected:
                                            selectedCategory == category.name,
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = category
                                                .name; // 👈 giữ nguyên key logic
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isCategoryExpanded = !isCategoryExpanded;
                            });
                          },
                          icon: Icon(
                            isCategoryExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 18,
                            color: Colors.black87,
                          ),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card List Section
          Expanded(
            child:
                (isLoading && isInitialLoad) // 👈 Chỉ hiển thị loading lần đầu
                ? _buildSkeletonList()
                : (errorMessage != null &&
                      isInitialLoad) // 👈 Chỉ hiển thị error lần đầu
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.errorPrefix,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    itemCount: filteredDeviceData.length,
                    itemBuilder: (context, index) {
                      return _buildDeviceCard(filteredDeviceData[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceItem device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: System, Status, Connection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getDeviceColor(device),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getSystemLabel(device.system),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getConnectionColor(
                    device.connection,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getConnectionText(device.connection),
                  style: TextStyle(
                    color: _getConnectionColor(device.connection),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // Device ID and Location
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.deviceIdLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Nút Device ID
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue.shade200),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, // ngang
                          vertical: 4, // 👈 giảm padding dọc => nút thấp hơn
                        ),
                        minimumSize: const Size(
                          0,
                          0,
                        ), // 👈 cho phép nút nhỏ nhất có thể
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // bỏ padding mặc định
                      ),
                      onPressed: () async {
                        bool loggedIn = await ApiServiceAuth.isLoggedIn();

                        if (loggedIn) {
                          if (canCreateAction) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  CreateActionDialog(device: device),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.errorLogin,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        device.deviceId,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (device.action)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.action,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),

                      GestureDetector(
                        onTap: () async {
                          bool loggedIn = await ApiServiceAuth.isLoggedIn();

                          if (loggedIn) {
                            // 👉 Nếu chưa login thì chuyển sang trang Login
                            if (canActionView) {
                              _showIssuesDialog(context, device.deviceId);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.errorLogin,
                                ),
                              ),
                            );
                          }

                          // if (!loggedIn) {
                          //   // 👉 Nếu chưa login thì chuyển sang trang Login
                          //   Navigator.pushNamed(context, FmcsRoutes.login);
                          // } else {
                          //   // 👉 Nếu đã login thì cho hiển thị dialog issues
                          //   _showIssuesDialog(context, device.deviceId);
                          // }
                        },
                        // onTap: () =>
                        //     _showIssuesDialog(context, device.deviceId),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple, // màu giống hình bạn gửi
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "A", // hoặc icon
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.locationLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${device.dataTime}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          // Divider
          Divider(color: Colors.grey.shade300, height: 1),

          const SizedBox(height: 2),

          // Sensor Data
          Row(
            children: [
              if (device.temperatureRaw != null)
                Expanded(
                  child: _buildSensorInfo(
                    label: AppLocalizations.of(context)!.temperatureLabel,
                    actualRaw: device.temperatureRaw,
                    actualText: device.temperature,
                    lower: device.tempLower,
                    target: device.tempTarget,
                    upper: device.tempUpper,
                  ),
                ),
              const SizedBox(width: 12),
              if (device.humidityRaw != null)
                Expanded(
                  child: _buildSensorInfo(
                    label: AppLocalizations.of(context)!.humidityLabel,
                    actualRaw: device.humidityRaw,
                    actualText: device.humidity,
                    lower: device.humidityLower,
                    target: device.humidityTarget,
                    upper: device.humidityUpper,
                  ),
                ),
              const SizedBox(width: 12),
              if (device.pressureRaw != null)
                Expanded(
                  child: _buildSensorInfo(
                    label: AppLocalizations.of(context)!.pressureLabel,
                    actualRaw: device.pressureRaw,
                    actualText: device.pressure,
                    lower: device.pressureLower,
                    target: device.pressureTarget,
                    upper: device.pressureUpper,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalCountLabel,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${device.totalCount}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${device.totalCountUpdateAt}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorInfo({
    required String label,
    required double? actualRaw,
    required String? actualText,
    required String? lower,
    required String? target,
    required String? upper,
  }) {
    final displayActual = (actualText != null && actualText.isNotEmpty)
        ? actualText
        : "N/A";
    final lowerVal = double.tryParse(lower ?? "");
    final upperVal = double.tryParse(upper ?? "");

    bool isLowerViolated = false;
    bool isUpperViolated = false;

    if (actualRaw != null && lowerVal != null && upperVal != null) {
      // Chuẩn hóa khoảng
      final minVal = lowerVal < upperVal ? lowerVal : upperVal;
      final maxVal = lowerVal > upperVal ? lowerVal : upperVal;

      // Nếu vượt ngưỡng dưới
      if (actualRaw < minVal) {
        if (minVal == lowerVal) {
          isLowerViolated = true;
        } else {
          isUpperViolated = true;
        }
      }

      // Nếu vượt ngưỡng trên
      if (actualRaw > maxVal) {
        if (maxVal == upperVal) {
          isUpperViolated = true;
        } else {
          isLowerViolated = true;
        }
      }
    } else {
      // Trường hợp chỉ có 1 ngưỡng
      if (actualRaw != null && lowerVal != null && actualRaw < lowerVal) {
        isLowerViolated = true;
      }
      if (actualRaw != null && upperVal != null && actualRaw > upperVal) {
        isUpperViolated = true;
      }
    }

    final isOutOfRange = isLowerViolated || isUpperViolated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          displayActual,
          style: TextStyle(
            color: isOutOfRange ? Colors.red : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        if (lower != null || target != null || upper != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lower != null)
                Text(
                  lower,
                  style: TextStyle(
                    fontSize: 10,
                    color: isLowerViolated ? Colors.red : Colors.black87,
                  ),
                ),
              if (target != null) ...[
                const SizedBox(width: 8),
                Text(
                  target,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ],
              if (upper != null) ...[
                const SizedBox(width: 8),
                Text(
                  upper,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUpperViolated ? Colors.red : Colors.black87,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, right: 8),
      itemCount: 6,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: chấm màu + tên system + chip connection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hàng DeviceId + Action + Location + Time (placeholder)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Action circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Container(height: 14, color: Colors.grey.shade300),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 40,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Container(height: 14, color: Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade300, height: 1),
          const SizedBox(height: 8),

          // Sensor rows: 3 cột + total count
          Row(
            children: [
              Expanded(child: _buildSkeletonSensor()),
              const SizedBox(width: 12),
              Expanded(child: _buildSkeletonSensor()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 40,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonSensor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 10, width: 60, color: Colors.grey.shade200),
        const SizedBox(height: 4),
        Container(height: 16, width: 40, color: Colors.grey.shade300),
        const SizedBox(height: 4),
        Container(height: 10, width: 70, color: Colors.grey.shade200),
      ],
    );
  }

  List<Widget> _buildAllChips({bool small = false}) {
    return [
      _buildStatusChip(
        "${statusSummary['connected']}/${statusSummary['total']}",
        Colors.green.shade100,
        Colors.green,
        small: small,
        icon: Icons.dns,
      ),
      _buildStatusChip(
        "${statusSummary['breached']}/${statusSummary['total']}",
        Colors.red.shade100,
        Colors.red,
        small: small,
        icon: Icons.error,
      ),
      _buildStatusChip(
        "${statusSummary['disconnected']}/${statusSummary['total']}",
        Colors.grey.shade200,
        Colors.grey,
        small: small,
        icon: Icons.warning,
      ),
    ];
  }

  Widget _buildStatusChip(
    String value,
    Color bgColor,
    Color iconColor, {
    bool small = false,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 8,
        vertical: small ? 4 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // 👈 căn giữa ngang
        crossAxisAlignment: CrossAxisAlignment.center, // 👈 căn giữa dọc
        children: [
          Icon(icon ?? Icons.info, size: small ? 14 : 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 13 : 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
              height: 1.1, // 👈 giúp text cao đều hơn với icon
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade700 : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // String _getConnectionText(String connection) {
  //   return connection[0].toUpperCase() + connection.substring(1);
  // }

  Color _getConnectionColor(String connection) {
    switch (connection.toLowerCase()) {
      case 'connected':
        return Colors.green;
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getDeviceColor(DeviceItem device) {
    if (device.issues.isEmpty) {
      return Colors.green; // Không có issue
    } else if (device.issues.any(
      (issue) => issue.contains("Device is Disconnected"),
    )) {
      return Colors.grey; // Bị ngắt kết nối
    } else {
      return Colors.red; // Có issue khác
    }
  }

  String _getSystemLabel(String system) {
    final l10n = AppLocalizations.of(context)!;

    switch (system) {
      case 'Cooling Tower':
        return l10n.systemCoolingTower;
      case 'Chiller':
        return l10n.systemChiller;
      case 'Vacuum Tank':
        return l10n.systemVacuumTank;
      case 'Air Dryer':
        return l10n.systemAirDryer;
      case 'Compressor':
        return l10n.systemCompressor;
      case 'End Air Pressure':
        return l10n.systemEndAirPressure;
      case 'Air Tank':
        return l10n.systemAirTank;
      case 'Air Conditioner':
        return l10n.systemAirConditioner;
      case 'Factory Temperature':
        return l10n.systemFactoryTemperature;
      default:
        // Nếu có system mới mà chưa khai báo, tạm hiển thị nguyên bản
        return system;
    }
  }

  String _getConnectionText(String connection) {
    final l10n = AppLocalizations.of(context)!;

    switch (connection.toLowerCase()) {
      case 'connected':
        return l10n.statusConnected;
      case 'disconnected':
        return l10n.statusDisconnected;
      default:
        return connection; // fallback
    }
  }

  void _showIssuesDialog(BuildContext context, String deviecId) {
    showDialog(
      context: context,
      builder: (context) => IssuesDialog(deviceId: deviecId),
    );
  }

  ///
  ///
  ///
}
