import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english,
  arabic;

  String get code => this == AppLanguage.english ? 'en' : 'ar';
  String get name => this == AppLanguage.english ? 'English' : 'العربية';
  TextDirection get textDirection =>
      this == AppLanguage.english ? TextDirection.ltr : TextDirection.rtl;
  Locale get locale => Locale(code);
}

class LanguageProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  late AppLanguage _currentLanguage;

  LanguageProvider(this._prefs) {
    _loadLanguage();
  }

  AppLanguage get currentLanguage => _currentLanguage;
  TextDirection get textDirection => _currentLanguage.textDirection;
  Locale get locale => _currentLanguage.locale;

  void _loadLanguage() {
    final savedLanguage = _prefs.getString('language');
    _currentLanguage =
        savedLanguage == 'ar' ? AppLanguage.arabic : AppLanguage.english;
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      await _prefs.setString('language', language.code);
      notifyListeners();
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage =
        _currentLanguage == AppLanguage.english
            ? AppLanguage.arabic
            : AppLanguage.english;
    await setLanguage(newLanguage);
  }
}
