import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_projections_provider.dart';

void main() {
  test('FinancialProjectionsNotifier initial state is empty list', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(financialProjectionsProvider);
    expect(state, isA<AsyncData<List<MonthlyFinancialRecord>>>());
    expect(state.value, isEmpty);
  });

  test('generate updates state with records', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final scenario = FinancialScenario(
      id: '1',
      name: 'Test',
      startDate: DateTime(2024),
      parameters: {},
    );

    await container
        .read(financialProjectionsProvider.notifier)
        .generate(scenario);

    final state = container.read(financialProjectionsProvider);
    expect(state.hasValue, true);
    expect(state.value!.length, 12); // Default duration is 12 months
  });
}
