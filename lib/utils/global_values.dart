import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  const GlobalValues._();

  static const isShowFlashCardAppDialogKey = 'isShowFlashCardAppDialog';
  static const isShowInAppReviewKey = 'isShowInAppReview';
  static const isShowOnboardingKey = 'isShowOnboarding';

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool get isShowFlashCardAppDialog => _sharedPreferences?.getBool(isShowFlashCardAppDialogKey) ?? false;

  static set isShowFlashCardAppDialog(bool value) {
    _sharedPreferences?.setBool(isShowFlashCardAppDialogKey, value);
  }

  static bool get isShowInAppReview => _sharedPreferences?.getBool(isShowInAppReviewKey) ?? false;

  static set isShowInAppReview(bool value) {
    _sharedPreferences?.setBool(isShowInAppReviewKey, value);
  }

  static bool get isShowOnboarding => _sharedPreferences?.getBool(isShowOnboardingKey) ?? false;

  static set isShowOnboarding(bool value) {
    _sharedPreferences?.setBool(isShowOnboardingKey, value);
  }
}