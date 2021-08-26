import 'package:chat_app/services/shared_preference_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, bool>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return OnboardingViewModel(sharedPreferencesService);
});

class OnboardingViewModel extends StateNotifier<bool> {
  final SharedPreferencesService sharedPreferencesService;

  OnboardingViewModel(this.sharedPreferencesService)
      : super(sharedPreferencesService.isOnboardingComplete());

  Future<void> completeOnboarding() async {
    await sharedPreferencesService.setOnboardingComplete();
    state = true;
  }

  bool get isOnboardingComplete => state;
}
