import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wordly/l10n/app_localizations.dart';
import 'package:wordly/providers/language_provider.dart';
import 'package:wordly/providers/word_provider.dart';
import 'package:wordly/providers/quiz_provider.dart';
import 'package:wordly/providers/chat_provider.dart';
import 'package:wordly/screens/main_screen.dart';

// App color constants
class AppColors {
  static const primary = Color(0xFF4F46E5); // Indigo Sky
  static const accent = Color(0xFFFB7185); // Soft Coral
  static const background = Color(0xFFF9FAFB); // Snow White
  static const textSecondary = Color(0xFF334155); // Slate Gray
  static const highlight = Color(0xFF5EEAD4); // Aqua Mint
  static const cardBackground = Color(0xFFE0E7FF); // Lavender Mist
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
        ChangeNotifierProvider(create: (_) => WordProvider(prefs)),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordly',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
          surface: AppColors.cardBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: AppColors.textSecondary,
          onSurface: AppColors.textSecondary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardTheme: CardTheme(
          color: AppColors.cardBackground,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.highlight,
          linearTrackColor: AppColors.cardBackground,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
