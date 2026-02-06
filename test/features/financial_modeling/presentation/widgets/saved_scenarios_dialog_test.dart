import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/repositories/financial_repository.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_projections_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_repository_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/widgets/saved_scenarios_dialog.dart';

// Mocks
class MockFinancialRepository implements FinancialRepository {
  List<FinancialScenario> scenarios = [
    FinancialScenario(
      id: '1',
      name: 'Scenario 1',
      startDate: DateTime(2023, 1, 1),
      durationMonths: 12,
      parameters: {},
    ),
    FinancialScenario(
      id: '2',
      name: 'Scenario 2',
      startDate: DateTime(2023, 1, 1),
      durationMonths: 24,
      parameters: {},
    ),
  ];

  @override
  Future<List<FinancialScenario>> getAllScenarios() async => scenarios;

  @override
  Future<FinancialScenario?> getScenario(String id) async =>
      scenarios.firstWhere((s) => s.id == id);

  @override
  Future<void> saveScenario(FinancialScenario scenario) async {}

  @override
  Future<void> deleteScenario(String id) async {
    scenarios.removeWhere((s) => s.id == id);
  }
}

class MockFinancialProjectionsNotifier extends FinancialProjectionsNotifier {
  FinancialScenario? generatedScenario;

  @override
  Future<void> generate(FinancialScenario scenario) async {
    generatedScenario = scenario;
    state = const AsyncValue.data([]);
  }
}

void main() {
  testWidgets('SavedScenariosDialog lists scenarios and handles actions', (
    tester,
  ) async {
    final mockRepo = MockFinancialRepository();
    final mockProjections = MockFinancialProjectionsNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          financialRepositoryProvider.overrideWithValue(mockRepo),
          financialProjectionsProvider.overrideWith(() => mockProjections),
        ],
        child: const MaterialApp(home: Scaffold(body: SavedScenariosDialog())),
      ),
    );

    // Allow FutureBuilder to resolve
    await tester.pumpAndSettle();

    // Verify List
    expect(find.text('Scenario 1'), findsOneWidget);
    expect(find.text('Scenario 2'), findsOneWidget);
    expect(
      find.textContaining('12 months'),
      findsOneWidget,
    ); // Part of subtitle
    expect(find.textContaining('24 months'), findsOneWidget);

    // Test Load (Tap item)
    await tester.tap(find.text('Scenario 1'));
    await tester.pumpAndSettle();

    expect(mockProjections.generatedScenario?.id, '1');

    // Re-pump to test delete (dialog closed on tap, so need to restart or use a different test block)
    // Actually, let's just create a new test block for delete because the dialog pops on load.
  });

  testWidgets('SavedScenariosDialog functionality handles delete', (
    tester,
  ) async {
    final mockRepo = MockFinancialRepository();
    // Ensure we have data
    expect(mockRepo.scenarios.length, 2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [financialRepositoryProvider.overrideWithValue(mockRepo)],
        child: const MaterialApp(home: Scaffold(body: SavedScenariosDialog())),
      ),
    );
    await tester.pumpAndSettle();

    // Test Delete (Scenario 1)
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify it's gone from UI
    expect(find.text('Scenario 1'), findsNothing);
    expect(find.text('Scenario 2'), findsOneWidget);

    // Check internal state of mock if possible, but UI check is usually enough
  });
}
