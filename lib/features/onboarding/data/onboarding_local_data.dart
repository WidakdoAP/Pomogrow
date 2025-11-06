import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomogrow/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingLocalData implements OnboardingRepository {
  static const _key = 'onboarding_completed';

  @override
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }
}
