import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/financial_repository_impl.dart';
import '../../domain/entities/financial_scenario.dart';
import '../../domain/repositories/financial_repository.dart';

part 'financial_repository_provider.g.dart';

@riverpod
FinancialRepository financialRepository(Ref ref) => FinancialRepositoryImpl();

@riverpod
class SavedScenarios extends _$SavedScenarios {
  @override
  FutureOr<List<FinancialScenario>> build() async {
    final repository = ref.watch(financialRepositoryProvider);
    return repository.getAllScenarios();
  }

  Future<void> saveScenario(FinancialScenario scenario) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(financialRepositoryProvider);
      await repository.saveScenario(scenario);
      return repository.getAllScenarios();
    });
  }

  Future<void> deleteScenario(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(financialRepositoryProvider);
      await repository.deleteScenario(id);
      return repository.getAllScenarios();
    });
  }
}
