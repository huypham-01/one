// lib/cmms/presentation/screens/report/waiting_repair_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/presentation/providers/waiting_repair_provider.dart';

// ---------------------------------------------------------------------------
// STATUS BADGE
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'on_wait':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'Waiting Repair';
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SHIFT BADGE
// ---------------------------------------------------------------------------

class _ShiftBadge extends StatelessWidget {
  final String shift;
  const _ShiftBadge({required this.shift});

  @override
  Widget build(BuildContext context) {
    final isDay = shift == 'day';
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

// ---------------------------------------------------------------------------
// DETAIL ROW
// ---------------------------------------------------------------------------

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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

// ---------------------------------------------------------------------------
// BREAKDOWN CARD
// ---------------------------------------------------------------------------

class _BreakdownCard extends StatefulWidget {
  final BreakdownReportModel item;
  const _BreakdownCard({required this.item});

  @override
  State<_BreakdownCard> createState() => _BreakdownCardState();
}

class _BreakdownCardState extends State<_BreakdownCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;

    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header (always visible) ────────────────────────────────
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.machineId,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        if ((item.category ?? '').isNotEmpty ||
                            (item.family ?? '').isNotEmpty)
                          Text(
                            [item.category, item.family]
                                .where((e) => e != null && e.isNotEmpty)
                                .join(' / '),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: item.status),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
                ],
              ),

              // ── Collapsible body ───────────────────────────────────────
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    // Issue description
                    if ((item.issueVi ?? '').isNotEmpty) ...[
                      Text(
                        item.issueVi!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ] else if ((item.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Details grid
                    Container(
                      padding: const EdgeInsets.all(8),
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
                                    _DetailRow(
                                      label: 'Reported By',
                                      value: item.reportedByName ?? '-',
                                    ),
                                    const SizedBox(height: 4),
                                    _DetailRow(
                                      label: 'Reported At',
                                      value: item.createdAt,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Shift badge
                    _ShiftBadge(shift: item.shift),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------

class WaitingRepairScreen extends StatefulWidget {
  const WaitingRepairScreen({super.key});

  @override
  State<WaitingRepairScreen> createState() => _WaitingRepairScreenState();
}

class _WaitingRepairScreenState extends State<WaitingRepairScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<WaitingRepairProvider>();
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Waiting Repair',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<WaitingRepairProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  provider.refresh();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Summary row ──────────────────────────────────────────────
          Consumer<WaitingRepairProvider>(
            builder: (context, provider, _) {
              if (provider.state == WaitingRepairState.loaded ||
                  provider.state == WaitingRepairState.loadingMore) {
                return _buildSummaryRow(provider.totalItems);
              }
              return const SizedBox.shrink();
            },
          ),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: Consumer<WaitingRepairProvider>(
              builder: (context, provider, _) {
                return _buildBody(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Row ───────────────────────────────────────────────────────────

  Widget _buildSummaryRow(int totalItems) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            '$totalItems record${totalItems != 1 ? 's' : ''} found',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ─────────────────────────────────────────────────────────────────

  Widget _buildBody(WaitingRepairProvider provider) {
    switch (provider.state) {
      case WaitingRepairState.initial:
      case WaitingRepairState.loading:
        return _buildLoading();

      case WaitingRepairState.error:
        return _buildError(provider.errorMessage, provider);

      case WaitingRepairState.loaded:
      case WaitingRepairState.loadingMore:
        if (provider.items.isEmpty) return _buildEmpty();
        return _buildList(provider);
    }
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF1E3A8A)),
          SizedBox(height: 16),
          Text('Loading...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildError(String message, WaitingRepairProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchReports(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No records found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(WaitingRepairProvider provider) {
    return RefreshIndicator(
      color: const Color(0xFF1E3A8A),
      onRefresh: () async {
        await provider.refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: provider.items.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == provider.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            );
          }
          return _BreakdownCard(item: provider.items[index]);
        },
      ),
    );
  }
}
