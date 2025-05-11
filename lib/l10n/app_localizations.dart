import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'Wordly',
      'currentStreak': 'Current Streak',
      'days': 'days',
      'example': 'Example:',
      'markAsLearned': 'Mark as Learned',
      'learned': 'Learned',
      'quiz': 'Quiz',
      'quizComingSoon': 'Quiz feature coming soon!',
      'switchLanguage': 'Switch Language',
    },
    'ar': {
      'appTitle': 'وردلي',
      'currentStreak': 'التتابع الحالي',
      'days': 'أيام',
      'example': 'مثال:',
      'markAsLearned': 'وضع علامة كمتعلم',
      'learned': 'تم التعلم',
      'quiz': 'اختبار',
      'quizComingSoon': 'ميزة الاختبار قادمة قريباً!',
      'switchLanguage': 'تغيير اللغة',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get currentStreak =>
      _localizedValues[locale.languageCode]!['currentStreak']!;
  String get days => _localizedValues[locale.languageCode]!['days']!;
  String get example => _localizedValues[locale.languageCode]!['example']!;
  String get markAsLearned =>
      _localizedValues[locale.languageCode]!['markAsLearned']!;
  String get learned => _localizedValues[locale.languageCode]!['learned']!;
  String get quiz => _localizedValues[locale.languageCode]!['quiz']!;
  String get quizComingSoon =>
      _localizedValues[locale.languageCode]!['quizComingSoon']!;
  String get switchLanguage =>
      _localizedValues[locale.languageCode]!['switchLanguage']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
