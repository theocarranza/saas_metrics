import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:saas_metrics/core/router/app_router.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';

import 'package:intl/intl.dart';

import '../../presentation/providers/financial_projections_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/kpi_card.dart';
import '../widgets/revenue_chart.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  ChartTimeframe _selectedTimeframe = ChartTimeframe.month;
  MonthlyFinancialRecord? _selectedRecord;

  @override
  Widget build(BuildContext context) {
    final projectionsAsync = ref.watch(financialProjectionsProvider);
    final isDesktop = Breakpoints.mediumAndUp.isActive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SaaS Financial Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              extended: Breakpoints.large.isActive(context),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                // NavigationRail requires at least 2 destinations.
                // Dummy hidden destination to satisfy API.
                NavigationRailDestination(
                  icon: Opacity(opacity: 0.0, child: Icon(Icons.circle)),
                  label: Text(''),
                  disabled: true,
                ),
              ],
              selectedIndex: 0,
              trailing: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (Breakpoints.large.isActive(context))
                            TextButton.icon(
                              onPressed: () => _signOut(context, ref),
                              icon: const Icon(Icons.logout, color: Colors.red),
                              label: const Text(
                                'Sign Out',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          else
                            IconButton(
                              onPressed: () => _signOut(context, ref),
                              icon: const Icon(Icons.logout),
                              tooltip: 'Sign Out',
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: projectionsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    key: const ValueKey('empty_state'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No projections generated yet.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please run a simulation to see the data.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

          // Find the record for the current month (or closest available)
          final now = DateTime.now();
          final currentRecord =
              _selectedRecord ??
              records.firstWhere(
                (r) => r.date.year == now.year && r.date.month == now.month,
                orElse: () => records.last,
              );

          final currencyFormat = NumberFormat.currency(
            locale: 'pt_BR',
            symbol: 'R\$',
          );

          final monthName = DateFormat('MMMM yyyy').format(currentRecord.date);

          // Prepare KPI data
          final kpis = [
            (
              'Total MRR',
              currencyFormat.format(currentRecord.saasMetrics.totalMrr),
              Icons.attach_money,
              Colors.green,
            ),
            (
              'Active Users',
              '${currentRecord.saasMetrics.activeCustomers}',
              Icons.people,
              Colors.blue,
            ),
            (
              'Gross Profit',
              currencyFormat.format(currentRecord.incomeStatement.grossProfit),
              Icons.trending_up,
              Colors.orange,
            ),
            (
              'Cash Balance',
              currencyFormat.format(currentRecord.cashFlow.endingBalance),
              Icons.account_balance_wallet,
              Colors.purple,
            ),
          ];

          return CustomScrollView(
            key: const ValueKey('content'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      'Key Metrics ($monthName)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent:
                        220, // Increased height for KPI cards to prevent overflow
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final kpi = kpis[index];
                    return KPICard(
                      title: kpi.$1,
                      value: kpi.$2,
                      icon: kpi.$3,
                      color: kpi.$4,
                    );
                  }, childCount: kpis.length),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Revenue Trend',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SegmentedButton<ChartTimeframe>(
                          segments: const [
                            ButtonSegment(
                              value: ChartTimeframe.month,
                              label: Text('Month'),
                              icon: Icon(Icons.calendar_view_month),
                            ),
                            ButtonSegment(
                              value: ChartTimeframe.year,
                              label: Text('Year'),
                              icon: Icon(Icons.calendar_today),
                            ),
                          ],
                          selected: {_selectedTimeframe},
                          onSelectionChanged:
                              (Set<ChartTimeframe> newSelection) {
                                setState(() {
                                  _selectedTimeframe = newSelection.first;
                                });
                              },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          height: 300,
                          child: RevenueChart(
                            records: records,
                            timeframe: _selectedTimeframe,
                            focusedRecord: currentRecord,
                            onRecordSelected: (record) {
                              setState(() {
                                _selectedRecord = record;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
          ),
        ],
      ),
);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logout();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}
