import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saas_metrics/features/onboarding/presentation/providers/onboarding_provider.dart';

part 'initial_simulation_provider.g.dart';

@riverpod
class InitialSimulation extends _$InitialSimulation {
  @override
  FutureOr<bool> build() async {
    final repository = ref.read(onboardingRepositoryProvider);
    return await repository.hasRunInitialSimulation();
  }

  Future<void> markAsRun() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(onboardingRepositoryProvider);
      await repository.markInitialSimulationAsRun();
      return true;
    });
  }
}
