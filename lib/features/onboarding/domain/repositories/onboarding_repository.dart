abstract class OnboardingRepository {
  /// Returns true if the user has already seen the onboarding flow.
  Future<bool> hasSeenOnboarding();

  /// Marks the onboarding flow as seen by the user.
  Future<void> markOnboardingAsSeen();

  /// Returns true if the initial simulation has been run.
  Future<bool> hasRunInitialSimulation();

  /// Marks the initial simulation as run.
  Future<void> markInitialSimulationAsRun();
}
