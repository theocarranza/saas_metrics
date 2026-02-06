import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saas_metrics/core/router/app_router.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_projections_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/initial_simulation_provider.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:uuid/uuid.dart';

class SimulationLoadingPage extends ConsumerStatefulWidget {
  const SimulationLoadingPage({super.key});

  @override
  ConsumerState<SimulationLoadingPage> createState() =>
      _SimulationLoadingPageState();
}

class _SimulationLoadingPageState extends ConsumerState<SimulationLoadingPage> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSimulation();
    });
  }

  Future<void> _startSimulation() async {
    final scenario = FinancialScenario(
      id: const Uuid().v4(),
      name: 'Initial Simulation',
      startDate: DateTime.now(),
      durationMonths: 36,
      parameters: {
        'starting_customers': 100,
        'arpa': 49.0,
        'churn_rate': 0.03,
        'new_customers_monthly': 15,
        'marketing_spend': 2000.0,
        'starting_cash': 50000.0,
        'tax_rate': 0.15,
        'cost_per_user': 5.0,
        'fixed_cogs': 1000.0,
        'fixed_opex': 5000.0,
        'capex': 0.0,
      },
    );

    try {
      // Run simulation
      await ref.read(financialProjectionsProvider.notifier).generate(scenario);

      // Mark as run
      await ref.read(initialSimulationProvider.notifier).markAsRun();

      // Navigate to dashboard
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(simulationProgressProvider);
    final projectionsState = ref.watch(financialProjectionsProvider);

    // In case there is an error in the provider state itself
    final error = _errorMessage ?? projectionsState.error?.toString();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                error != null ? Icons.error_outline : Icons.analytics,
                size: 80,
                color: error != null ? Colors.red : Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                error != null
                    ? 'Simulation Failed'
                    : 'Preparing Your Dashboard',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                error ??
                    'We are generating your initial financial projections based on industry benchmarks.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: error != null ? Colors.red : Colors.grey,
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _startSimulation();
                  },
                  child: const Text('Retry Simulation'),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Go Back to Login'),
                ),
              ] else ...[
                const SizedBox(height: 48),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
