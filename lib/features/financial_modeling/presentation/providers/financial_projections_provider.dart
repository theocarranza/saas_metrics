import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/domain/usecases/generate_financial_projections.dart';
import 'package:saas_metrics/features/auth/presentation/providers/auth_provider.dart';

part 'financial_projections_provider.g.dart';

@riverpod
class SimulationProgress extends _$SimulationProgress {
  @override
  double build() => 0.0;

  void update(double progress) => state = progress;
}

@riverpod
class FinancialProjectionsNotifier extends _$FinancialProjectionsNotifier {
  @override
  FutureOr<List<MonthlyFinancialRecord>> build() async {
    // Watch Auth Provider to react to session changes
    final authState = ref.watch(authProvider);

    // If auth is loading, we can just return empty or previous state,
    // but better to wait or return empty for now.
    if (authState.isLoading) {
      return [];
    }

    // If not authenticated or error, return empty list (effectively clearing data)
    if (authState.value == null || !authState.value!.isValid) {
      return [];
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('financial_projections');

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((e) => MonthlyFinancialRecord.fromMap(e)).toList();
      } catch (e) {
        // Fallback or error logging if needed
        return [];
      }
    }

    return [];
  }

  Future<void> generate(FinancialScenario scenario) async {
    state = const AsyncValue.loading();
    ref.read(simulationProgressProvider.notifier).update(0.0);

    state = await AsyncValue.guard(() async {
      final useCase = GenerateFinancialProjections();
      final result = await useCase(
        scenario,
        onProgress: (progress) {
          ref.read(simulationProgressProvider.notifier).update(progress);
        },
      );

      // Persist data
      final prefs = await SharedPreferences.getInstance();
      final jsonList = result.map((e) => e.toMap()).toList();
      await prefs.setString('financial_projections', jsonEncode(jsonList));

      return result;
    });
  }
}
