import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/financial_projections_provider.dart';
import '../../domain/entities/financial_scenario.dart';
import '../providers/financial_repository_provider.dart';

class SimulationDialog extends ConsumerStatefulWidget {
  const SimulationDialog({super.key});

  @override
  ConsumerState<SimulationDialog> createState() => _SimulationDialogState();
}

class _SimulationDialogState extends ConsumerState<SimulationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'My Simulation');
  final _startingCustomersController = TextEditingController(text: '100');
  final _newCustomersController = TextEditingController(text: '10');
  final _arpaController = TextEditingController(text: '50.0');
  final _churnRateController = TextEditingController(text: '0.05');
  final _marketingSpendController = TextEditingController(text: '1000.0');
  final _fixedOpexController = TextEditingController(text: '5000.0');
  final _taxRateController = TextEditingController(text: '0.15');
  final _durationController = TextEditingController(text: '12');

  @override
  void dispose() {
    _nameController.dispose();
    _startingCustomersController.dispose();
    _newCustomersController.dispose();
    _arpaController.dispose();
    _churnRateController.dispose();
    _marketingSpendController.dispose();
    _fixedOpexController.dispose();
    _taxRateController.dispose();
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
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Scenario Name',
                  isDense: true,
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Growth Drivers'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startingCustomersController,
                      decoration: const InputDecoration(
                        labelText: 'Starting Users',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _newCustomersController,
                      decoration: const InputDecoration(
                        labelText: 'New / Month',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _arpaController,
                      decoration: const InputDecoration(
                        labelText: 'ARPA',
                        prefixText: 'R\$ ',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateDouble(v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _churnRateController,
                      decoration: const InputDecoration(
                        labelText: 'Churn Rate',
                        suffixText: '%',
                        helperText: '0.05 = 5%',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateDouble(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Costs & Expenses'),
              TextFormField(
                controller: _marketingSpendController,
                decoration: const InputDecoration(
                  labelText: 'Marketing Spend (Monthly)',
                  prefixText: 'R\$ ',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateDouble(v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fixedOpexController,
                decoration: const InputDecoration(
                  labelText: 'Fixed OpEx (Monthly)',
                  prefixText: 'R\$ ',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateDouble(v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxRateController,
                decoration: const InputDecoration(
                  labelText: 'Tax Rate',
                  suffixText: '%',
                  helperText: '0.15 = 15%',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateDouble(v),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Scenario Settings'),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (Months)',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateNumber(v),
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
          child: const Text('Run & Save'),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String? _validateNumber(String? value) {
    return value == null || int.tryParse(value) == null
        ? 'Enter a valid number'
        : null;
  }

  String? _validateDouble(String? value) {
    return value == null || double.tryParse(value) == null
        ? 'Enter a valid number'
        : null;
  }

  Future<void> _runSimulation() async {
    if (!_formKey.currentState!.validate()) return;

    final scenario = FinancialScenario(
      id: const Uuid().v4(),
      name: _nameController.text,
      startDate: DateTime.now(),
      durationMonths: int.parse(_durationController.text),
      parameters: {
        'starting_customers': int.parse(_startingCustomersController.text),
        'new_customers_monthly': int.parse(_newCustomersController.text),
        'arpa': double.parse(_arpaController.text),
        'churn_rate': double.parse(_churnRateController.text),
        'marketing_spend': double.parse(_marketingSpendController.text),
        'fixed_opex': double.parse(_fixedOpexController.text),
        'tax_rate': double.parse(_taxRateController.text),
      },
    );

    Navigator.of(context).pop();
    
    // Save scenario
    await ref.read(savedScenariosProvider.notifier).saveScenario(scenario);

    // Run simulation
    await ref.read(financialProjectionsProvider.notifier).generate(scenario);
  }
}
