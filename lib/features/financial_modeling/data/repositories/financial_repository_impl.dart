import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/financial_scenario.dart';
import '../../domain/repositories/financial_repository.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  static const String _storageKey = 'financial_scenarios';

  @override
  Future<List<FinancialScenario>> getAllScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((e) => FinancialScenario.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of corruption, return empty or handle error
      return [];
    }
  }

  @override
  Future<FinancialScenario?> getScenario(String id) async {
    final scenarios = await getAllScenarios();
    try {
      return scenarios.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveScenario(FinancialScenario scenario) async {
    final prefs = await SharedPreferences.getInstance();
    final scenarios = await getAllScenarios();

    final index = scenarios.indexWhere((s) => s.id == scenario.id);
    if (index >= 0) {
      scenarios[index] = scenario;
    } else {
      scenarios.add(scenario);
    }

    final jsonList = scenarios.map((s) => s.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  Future<void> deleteScenario(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final scenarios = await getAllScenarios();

    scenarios.removeWhere((s) => s.id == id);

    final jsonList = scenarios.map((s) => s.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
