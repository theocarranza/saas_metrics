import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_projections_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/widgets/simulation_dialog.dart';

// Mock Notifier
class MockFinancialProjectionsNotifier extends FinancialProjectionsNotifier {
  FinancialScenario? lastScenario;

  @override
  Future<void> generate(FinancialScenario scenario) async {
    lastScenario = scenario;
    // Simulate empty result
    state = const AsyncValue.data([]);
  }
}

void main() {
  testWidgets('SimulationDialog validates and submits correct values', (tester) async {
    final mockNotifier = MockFinancialProjectionsNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          financialProjectionsProvider.overrideWith(() => mockNotifier),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SimulationDialog(),
          ),
        ),
      ),
    );

    // Verify initial values
    expect(find.text('100'), findsOneWidget); // Starting Customers
    expect(find.text('10'), findsOneWidget); // New / Month
    expect(find.text('1000.0'), findsOneWidget); // Marketing Spend

    // Enter new values
    await tester.enterText(find.widgetWithText(TextFormField, 'New / Month'), '20');
    await tester.enterText(find.widgetWithText(TextFormField, 'Marketing Spend (Monthly)'), '2000.0');
    await tester.enterText(find.widgetWithText(TextFormField, 'Tax Rate'), '0.20');

    // Run Simulation
    await tester.tap(find.text('Run Simulation'));
    await tester.pumpAndSettle();

    // Verify Generate was called with correct values
    expect(mockNotifier.lastScenario, isNotNull);
    final params = mockNotifier.lastScenario!.parameters;
    
    expect(params['new_customers_monthly'], 20);
    expect(params['marketing_spend'], 2000.0);
    expect(params['tax_rate'], 0.20);
  });
}
