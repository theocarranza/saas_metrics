import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saas_metrics/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:saas_metrics/features/onboarding/domain/repositories/onboarding_repository.dart';

part 'onboarding_provider.g.dart';

@riverpod
OnboardingRepository onboardingRepository(Ref ref) => OnboardingRepositoryImpl();

@riverpod
class Onboarding extends _$Onboarding {
  @override
  FutureOr<bool> build() async {
    final repository = ref.read(onboardingRepositoryProvider);
    return await repository.hasSeenOnboarding();
  }

  Future<void> completeOnboarding() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(onboardingRepositoryProvider);
      await repository.markOnboardingAsSeen();
      return true;
    });
  }
}
