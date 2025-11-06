abstract class OnboardingRepository {
  Future<void> setOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}
