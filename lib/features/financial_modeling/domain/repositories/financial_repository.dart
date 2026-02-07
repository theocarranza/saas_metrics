import '../entities/financial_scenario.dart';

/// Contract for persisting and retrieving financial scenarios.
abstract class FinancialRepository {
  /// Retrieves all saved scenarios.
  Future<List<FinancialScenario>> getAllScenarios();

  /// Retrieves a saved scenario by its ID.
  Future<FinancialScenario?> getScenario(String id);

  /// Saves a financial scenario.
  Future<void> saveScenario(FinancialScenario scenario);

  /// Deletes a financial scenario.
  Future<void> deleteScenario(String id);
}
