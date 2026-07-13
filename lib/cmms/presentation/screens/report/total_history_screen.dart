import 'package:flutter/material.dart';

// --- MODELS ---

enum IssueStatus { onWait, fixed, inProgress, cancelled }

enum Shift { day, night }

class IssueEntity {
  final String machineCode;
  final String category;
  final String family;
  final String issueCode;
  final String issueDescription;
  final Shift shift;
  final IssueStatus status;
  final String reportedBy;
  final String reportedAt;
  final String? method;
  final String? fixedBy;
  final String? fixedAt;
  final String downtime;

  IssueEntity({
    required this.machineCode,
    required this.category,
    required this.family,
    required this.issueCode,
    required this.issueDescription,
    required this.shift,
    required this.status,
    required this.reportedBy,
    required this.reportedAt,
    this.method,
    this.fixedBy,
    this.fixedAt,
    required this.downtime,
  });
}

// --- MOCK DATA ---

final List<IssueEntity> mockIssues = [
  IssueEntity(
    machineCode: 'VP04008',
    category: 'Molding',
    family: 'Injection',
    issueCode: 'ERR-001',
    issueDescription:
        'Oil leak in main hydraulic cylinder causing pressure drop',
    shift: Shift.day,
    status: IssueStatus.fixed,
    reportedBy: 'Nguyễn Văn A',
    reportedAt: '2026-06-18 10:32',
    method: 'Replaced O-ring and refilled hydraulic oil',
    fixedBy: 'Nguyễn Văn B',
    fixedAt: '2026-06-18 10:36',
    downtime: '4 mins',
  ),
  IssueEntity(
    machineCode: 'VI01009',
    category: 'Assembly',
    family: 'Conveyor',
    issueCode: 'ERR-005',
    issueDescription: 'Motor overheating during high-speed operation',
    shift: Shift.night,
    status: IssueStatus.inProgress,
    reportedBy: 'Trần Thị C',
    reportedAt: '2026-06-19 22:15',
    method: null,
    fixedBy: null,
    fixedAt: null,
    downtime: 'Ongoing',
  ),
  IssueEntity(
    machineCode: 'VP04012',
    category: 'Molding',
    family: 'Injection',
    issueCode: 'ERR-002',
    issueDescription: 'Temperature sensor failure on barrel zone 3',
    shift: Shift.day,
    status: IssueStatus.onWait,
    reportedBy: 'Lê Văn D',
    reportedAt: '2026-06-20 08:00',
    method: null,
    fixedBy: null,
    fixedAt: null,
    downtime: 'Pending',
  ),
  IssueEntity(
    machineCode: 'CNC001',
    category: 'Machining',
    family: 'Milling',
    issueCode: 'ERR-010',
    issueDescription: 'Tool broken during roughing pass',
    shift: Shift.night,
    status: IssueStatus.cancelled,
    reportedBy: 'Phạm Văn E',
    reportedAt: '2026-06-20 02:30',
    method: 'False alarm, wrong program loaded',
    fixedBy: 'Admin',
    fixedAt: '2026-06-20 02:45',
    downtime: '15 mins',
  ),
  IssueEntity(
    machineCode: 'VP04008',
    category: 'Molding',
    family: 'Injection',
    issueCode: 'ERR-003',
    issueDescription: 'Ejector pin stuck forward',
    shift: Shift.day,
    status: IssueStatus.fixed,
    reportedBy: 'Nguyễn Văn A',
    reportedAt: '2026-06-21 14:20',
    method: 'Lubricated and realigned ejector plate',
    fixedBy: 'Nguyễn Văn B',
    fixedAt: '2026-06-21 14:50',
    downtime: '30 mins',
  ),
  IssueEntity(
    machineCode: 'PKG005',
    category: 'Packaging',
    family: 'Wrapper',
    issueCode: 'ERR-022',
    issueDescription: 'Film tension error, cutting mechanism jammed',
    shift: Shift.night,
    status: IssueStatus.inProgress,
    reportedBy: 'Đỗ Thị F',
    reportedAt: '2026-06-22 01:10',
    method: null,
    fixedBy: null,
    fixedAt: null,
    downtime: 'Ongoing',
  ),
  IssueEntity(
    machineCode: 'VI01015',
    category: 'Assembly',
    family: 'Robot',
    issueCode: 'ERR-018',
    issueDescription: 'Axis 4 servo error overload',
    shift: Shift.day,
    status: IssueStatus.onWait,
    reportedBy: 'Hoàng Văn G',
    reportedAt: '2026-06-23 09:45',
    method: null,
    fixedBy: null,
    fixedAt: null,
    downtime: 'Pending',
  ),
  IssueEntity(
    machineCode: 'VP04020',
    category: 'Molding',
    family: 'Injection',
    issueCode: 'ERR-004',
    issueDescription: 'Hopper loader not feeding material',
    shift: Shift.day,
    status: IssueStatus.fixed,
    reportedBy: 'Lê Văn D',
    reportedAt: '2026-06-24 11:00',
    method: 'Cleared blockage in material hose',
    fixedBy: 'Trần Văn H',
    fixedAt: '2026-06-24 11:15',
    downtime: '15 mins',
  ),
  IssueEntity(
    machineCode: 'TST002',
    category: 'Quality',
    family: 'Tester',
    issueCode: 'ERR-030',
    issueDescription: 'Calibration out of tolerance',
    shift: Shift.night,
    status: IssueStatus.cancelled,
    reportedBy: 'Vũ Thị I',
    reportedAt: '2026-06-25 04:00',
    method: 'Recalibrated successfully without repair',
    fixedBy: 'Vũ Thị I',
    fixedAt: '2026-06-25 04:10',
    downtime: '10 mins',
  ),
  IssueEntity(
    machineCode: 'VI01009',
    category: 'Assembly',
    family: 'Conveyor',
    issueCode: 'ERR-006',
    issueDescription: 'Belt snapped at joining seam',
    shift: Shift.day,
    status: IssueStatus.fixed,
    reportedBy: 'Trần Thị C',
    reportedAt: '2026-06-26 13:30',
    method: 'Replaced conveyor belt section',
    fixedBy: 'Nguyễn Văn B',
    fixedAt: '2026-06-26 15:00',
    downtime: '90 mins',
  ),
];

// --- WIDGETS ---

class StatusBadge extends StatelessWidget {
  final IssueStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case IssueStatus.onWait:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = 'On Wait';
        break;
      case IssueStatus.fixed:
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Fixed';
        break;
      case IssueStatus.inProgress:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = 'In Progress';
        break;
      case IssueStatus.cancelled:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ShiftBadge extends StatelessWidget {
  final Shift shift;

  const ShiftBadge({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    final isDay = shift == Shift.day;
    final color = isDay ? Colors.amber.shade700 : Colors.indigo.shade400;
    final icon = isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded;
    final text = isDay ? 'Day Shift' : 'Night Shift';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by machine ID, issue...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                // Handle filter action
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final IssueEntity issue;

  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Add navigation to detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.precision_manufacturing,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      issue.machineCode,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  StatusBadge(status: issue.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Body
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${issue.category} / ${issue.family}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    issue.issueCode,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                issue.issueDescription,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Details 2 columns
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Reported By', issue.reportedBy),
                              const SizedBox(height: 4),
                              _buildDetailRow('Reported At', issue.reportedAt),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Fixed By', issue.fixedBy ?? '-'),
                              const SizedBox(height: 4),
                              _buildDetailRow('Fixed At', issue.fixedAt ?? '-'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (issue.method != null) ...[
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Method:',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              issue.method!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Footer
              Row(
                children: [
                  ShiftBadge(shift: issue.shift),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          issue.downtime,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View Detail',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// --- SCREEN ---

class TotalHistoryScreen extends StatefulWidget {
  const TotalHistoryScreen({super.key});

  @override
  State<TotalHistoryScreen> createState() => _TotalHistoryScreenState();
}

class _TotalHistoryScreenState extends State<TotalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Total History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A), // cusBlue from other screens
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              itemCount: mockIssues.length,
              itemBuilder: (context, index) {
                return IssueCard(issue: mockIssues[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
