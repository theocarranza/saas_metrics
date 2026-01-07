import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';

import '../../presentation/providers/financial_projections_provider.dart';
import '../widgets/kpi_card.dart';
import '../widgets/revenue_chart.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectionsAsync = ref.watch(financialProjectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SaaS Financial Dashboard',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _runSimulation(ref),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Run Simulation'),
      ),
      body: projectionsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
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
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _runSimulation(ref),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Generate Projections'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final lastMonth = records.last;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Metrics (Month 12)',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: KPICard(
                        title: 'Total MRR',
                        value:
                            '\$${lastMonth.saasMetrics.totalMrr.toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: KPICard(
                        title: 'Active Users',
                        value: '${lastMonth.saasMetrics.activeCustomers}',
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: KPICard(
                        title: 'Gross Profit',
                        value:
                            '\$${lastMonth.incomeStatement.grossProfit.toStringAsFixed(0)}',
                        icon: Icons.trending_up,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: KPICard(
                        title: 'Cash Balance',
                        value:
                            '\$${lastMonth.cashFlow.endingBalance.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Revenue Trend',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(height: 300, child: RevenueChart(records: records)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _runSimulation(WidgetRef ref) {
    // Default scenario for demo
    final scenario = FinancialScenario(
      id: 'demo',
      name: 'Demo Scenario',
      startDate: DateTime.now(),
      parameters: const {
        'starting_customers': 100,
        'new_customers_monthly': 10,
        'arpa': 50.0,
        'churn_rate': 0.05,
        'cost_per_user': 5.0,
        'fixed_opex': 1000.0,
        'marketing_spend': 500.0,
        'starting_cash': 10000.0,
        'tax_rate': 0.2,
      },
    );
    ref.read(financialProjectionsProvider.notifier).generate(scenario);
  }
}
