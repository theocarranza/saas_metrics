import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/domain/usecases/generate_financial_projections.dart';

part 'financial_projections_provider.g.dart';

@riverpod
class FinancialProjectionsNotifier extends _$FinancialProjectionsNotifier {
  @override
  FutureOr<List<MonthlyFinancialRecord>> build() {
    return [];
  }

  Future<void> generate(FinancialScenario scenario) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = GenerateFinancialProjections();
      return useCase(scenario);
    });
  }
}
