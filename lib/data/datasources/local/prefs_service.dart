import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _isOnboardedKey = 'is_onboarded';
  static const String _authTokenKey = 'auth_token';
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  static Future<PrefsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsService(prefs);
  }

  // Onboarding
  bool get isOnboarded => _prefs.getBool(_isOnboardedKey) ?? false;
  Future<void> setOnboarded() => _prefs.setBool(_isOnboardedKey, true);

  // Auth Token
  String? get authToken => _prefs.getString(_authTokenKey);
  Future<void> saveAuthToken(String token) =>
      _prefs.setString(_authTokenKey, token);
  Future<void> clearAuthToken() => _prefs.remove(_authTokenKey);

  // Theme
  String get themeMode => _prefs.getString(_themeModeKey) ?? 'dark';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  Future<void> clearAll() => _prefs.clear();
}
