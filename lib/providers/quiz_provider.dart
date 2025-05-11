import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:wordly/models/word.dart';

class QuizQuestion {
  final Word word;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.word,
    required this.options,
    required this.correctIndex,
  });
}

class QuizProvider with ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizComplete = false;
  bool _isLoading = true;

  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizComplete => _isQuizComplete;
  bool get isLoading => _isLoading;
  QuizQuestion? get currentQuestion =>
      _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;
  double get progress =>
      _questions.isEmpty ? 0 : _currentQuestionIndex / _questions.length;

  Future<void> generateQuiz(List<Word> words) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _questions = [];
    final random = Random();

    // Generate 5 questions
    for (var i = 0; i < 5 && i < words.length; i++) {
      final word = words[i];
      final allTranslations = words.map((w) => w.arabicTranslation).toList();
      allTranslations.remove(word.arabicTranslation);

      // Shuffle and take 3 wrong options
      allTranslations.shuffle(random);
      final wrongOptions = allTranslations.take(3).toList();

      // Create options list with correct answer
      final options = [...wrongOptions, word.arabicTranslation];
      options.shuffle(random);

      _questions.add(
        QuizQuestion(
          word: word,
          options: options,
          correctIndex: options.indexOf(word.arabicTranslation),
        ),
      );
    }

    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    _isLoading = false;
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (_isQuizComplete || _currentQuestionIndex >= _questions.length) return;

    final question = _questions[_currentQuestionIndex];
    if (selectedIndex == question.correctIndex) {
      _score++;
    }

    _currentQuestionIndex++;

    if (_currentQuestionIndex >= _questions.length) {
      _isQuizComplete = true;
    }

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    notifyListeners();
  }
}
