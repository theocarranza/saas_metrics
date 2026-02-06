abstract class OnboardingRepository {
  /// Returns true if the user has already seen the onboarding flow.
  Future<bool> hasSeenOnboarding();

  /// Marks the onboarding flow as seen by the user.
  Future<void> markOnboardingAsSeen();
}
