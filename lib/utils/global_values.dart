import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  const GlobalValues._();

  static const isShowFlashCardAppDialogKey = 'isShowFlashCardAppDialog';
  static const isShowInAppReviewKey = 'isShowInAppReview';
  static const isShowOnboardingKey = 'isShowOnboarding';
  static const boughtNoAdsTimeKey = 'boughtNoAds';

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

  static int? get boughtNoAdsTime {
    final result = _sharedPreferences?.getInt(boughtNoAdsTimeKey);
    return result;
  }

  static Future<bool>? setBoughtNoAdsTime(int? value) {
    if (value == null) {
      return _sharedPreferences?.remove(boughtNoAdsTimeKey);
    }
    return _sharedPreferences?.setInt(boughtNoAdsTimeKey, value);
  }
}