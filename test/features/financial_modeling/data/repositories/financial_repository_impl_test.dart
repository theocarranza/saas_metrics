import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/data/repositories/financial_repository_impl.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FinancialRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = FinancialRepositoryImpl();
  });

  group('FinancialRepositoryImpl', () {
    final tScenario = FinancialScenario(
      id: '1',
      name: 'Test Scenario',
      startDate: DateTime(2023, 1, 1),
      durationMonths: 12,
      parameters: const {'test': 1},
    );

    test('should save and retrieve scenarios', () async {
      // Act
      await repository.saveScenario(tScenario);
      final result = await repository.getAllScenarios();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, tScenario.id);
      expect(result.first.name, tScenario.name);

      // Verify specific values
      expect(result.first.startDate, tScenario.startDate);
      expect(result.first.parameters, tScenario.parameters);
    });

    test('should update existing scenario', () async {
      // Arrange
      await repository.saveScenario(tScenario);
      final updatedScenario = tScenario.copyWith(name: 'Updated Name');

      // Act
      await repository.saveScenario(updatedScenario);
      final result = await repository.getAllScenarios();

      // Assert
      expect(result.length, 1);
      expect(result.first.name, 'Updated Name');
    });

    test('should delete scenario', () async {
      // Arrange
      await repository.saveScenario(tScenario);

      // Act
      await repository.deleteScenario(tScenario.id);
      final result = await repository.getAllScenarios();

      // Assert
      expect(result, isEmpty);
    });

    test('should return empty list when no data', () async {
      // Act
      final result = await repository.getAllScenarios();

      // Assert
      expect(result, isEmpty);
    });
  });
}
