import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/financial_projections_provider.dart';
import '../../domain/entities/financial_scenario.dart';

class SimulationDialog extends ConsumerStatefulWidget {
  const SimulationDialog({super.key});

  @override
  ConsumerState<SimulationDialog> createState() => _SimulationDialogState();
}

class _SimulationDialogState extends ConsumerState<SimulationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _startingCustomersController = TextEditingController(text: '100');
  final _arpaController = TextEditingController(text: '50.0');
  final _churnRateController = TextEditingController(text: '0.05');
  final _durationController = TextEditingController(text: '12');

  @override
  void dispose() {
    _startingCustomersController.dispose();
    _arpaController.dispose();
    _churnRateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Financial Simulation'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _startingCustomersController,
                decoration: const InputDecoration(
                  labelText: 'Starting Customers',
                  helperText: 'Initial active customer base',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                    ? 'Enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arpaController,
                decoration: const InputDecoration(
                  labelText: 'ARPA (Monthly)',
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                    ? 'Enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _churnRateController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Churn Rate',
                  suffixText: '%',
                  helperText: 'Example: 0.05 for 5%',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                    ? 'Enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Simulation Duration (Months)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                    ? 'Enter a valid number'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _runSimulation,
          child: const Text('Run Simulation'),
        ),
      ],
    );
  }

  Future<void> _runSimulation() async {
    if (!_formKey.currentState!.validate()) return;

    final scenario = FinancialScenario(
      id: const Uuid().v4(),
      name: 'Custom Simulation',
      startDate: DateTime.now(),
      durationMonths: int.parse(_durationController.text),
      parameters: {
        'starting_customers': int.parse(_startingCustomersController.text),
        'arpa': double.parse(_arpaController.text),
        'churn_rate': double.parse(_churnRateController.text),
        'new_customers_monthly': 10, // Default value for now
        'marketing_spend': 1000.0,
        'fixed_opex': 5000.0,
        'tax_rate': 0.15,
      },
    );

    Navigator.of(context).pop();
    await ref.read(financialProjectionsProvider.notifier).generate(scenario);
  }
}
