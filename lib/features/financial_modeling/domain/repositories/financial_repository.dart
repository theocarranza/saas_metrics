import '../entities/financial_scenario.dart';

/// Contract for persisting and retrieving financial scenarios.
abstract class FinancialRepository {
  /// Retrieves a saved scenario by its ID.
  Future<FinancialScenario> getScenario(String id);

  /// Saves a financial scenario.
  Future<void> saveScenario(FinancialScenario scenario);
}
