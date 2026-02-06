import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saas_metrics/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:saas_metrics/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('OnboardingRepositoryImpl', () {
    late OnboardingRepositoryImpl repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = OnboardingRepositoryImpl();
    });

    test('hasSeenOnboarding returns false by default', () async {
      final result = await repository.hasSeenOnboarding();
      expect(result, isFalse);
    });

    test('markOnboardingAsSeen updates value to true', () async {
      await repository.markOnboardingAsSeen();
      final result = await repository.hasSeenOnboarding();
      expect(result, isTrue);
    });
  });

  group('OnboardingNotifier', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is false', () async {
      final state = await container.read(onboardingProvider.future);
      expect(state, isFalse);
    });

    test('completeOnboarding updates state to true', () async {
      await container.read(onboardingProvider.notifier).completeOnboarding();
      final state = await container.read(onboardingProvider.future);
      expect(state, isTrue);
    });
  });
}
