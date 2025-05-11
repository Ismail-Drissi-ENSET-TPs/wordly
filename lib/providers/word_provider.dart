import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/models/word.dart';

class WordProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  List<Word> _allWords = [];
  List<Word> _displayedWords = [];
  int _currentPage = 1;
  static const int wordsPerPage = 5;
  bool _hasMoreWords = true;
  bool _isLoading = false;

  WordProvider(this._prefs) {
    _loadData();
  }

  List<Word> get displayedWords => _displayedWords;
  int get streak => _prefs.getInt('streak') ?? 0;
  bool get hasMoreWords => _hasMoreWords;
  bool get isLoading => _isLoading;

  void _loadData() {
    _loadDailyWords();
  }

  void _loadDailyWords() {
    final wordsJson = _prefs.getString('dailyWords');
    if (wordsJson != null) {
      final List<dynamic> decoded = json.decode(wordsJson);
      _allWords = decoded.map((item) => Word.fromJson(item)).toList();
    } else {
      _generateDailyWords();
    }
    _loadNextPage();
  }

  void _generateDailyWords() {
    // Sample English words with Arabic translations
    _allWords = [
      Word(
        englishWord: 'Hello',
        arabicTranslation: 'مرحباً',
        englishExample: 'Hello, how are you today?',
        arabicExample: 'مرحباً، كيف حالك اليوم؟',
        audioUrl: 'https://example.com/hello.mp3',
      ),
      Word(
        englishWord: 'Goodbye',
        arabicTranslation: 'مع السلامة',
        englishExample: 'Goodbye, see you tomorrow!',
        arabicExample: 'مع السلامة، أراك غداً!',
        audioUrl: 'https://example.com/goodbye.mp3',
      ),
      Word(
        englishWord: 'Thank you',
        arabicTranslation: 'شكراً لك',
        englishExample: 'Thank you for your help.',
        arabicExample: 'شكراً لك على مساعدتك.',
        audioUrl: 'https://example.com/thankyou.mp3',
      ),
      Word(
        englishWord: 'Please',
        arabicTranslation: 'من فضلك',
        englishExample: 'Please, can you help me?',
        arabicExample: 'من فضلك، هل يمكنك مساعدتي؟',
        audioUrl: 'https://example.com/please.mp3',
      ),
      Word(
        englishWord: 'Sorry',
        arabicTranslation: 'عذراً',
        englishExample: 'I am sorry for being late.',
        arabicExample: 'عذراً على التأخير.',
        audioUrl: 'https://example.com/sorry.mp3',
      ),
      // Additional words
      Word(
        englishWord: 'Welcome',
        arabicTranslation: 'أهلاً وسهلاً',
        englishExample: 'Welcome to our home!',
        arabicExample: 'أهلاً وسهلاً في منزلنا!',
        audioUrl: 'https://example.com/welcome.mp3',
      ),
      Word(
        englishWord: 'Good morning',
        arabicTranslation: 'صباح الخير',
        englishExample: 'Good morning, how did you sleep?',
        arabicExample: 'صباح الخير، كيف نمت؟',
        audioUrl: 'https://example.com/goodmorning.mp3',
      ),
      Word(
        englishWord: 'Good night',
        arabicTranslation: 'تصبح على خير',
        englishExample: 'Good night, sleep well!',
        arabicExample: 'تصبح على خير، نم جيداً!',
        audioUrl: 'https://example.com/goodnight.mp3',
      ),
      Word(
        englishWord: 'Excuse me',
        arabicTranslation: 'عذراً',
        englishExample: 'Excuse me, could you help me?',
        arabicExample: 'عذراً، هل يمكنك مساعدتي؟',
        audioUrl: 'https://example.com/excuseme.mp3',
      ),
      Word(
        englishWord: 'See you later',
        arabicTranslation: 'أراك لاحقاً',
        englishExample: 'See you later, take care!',
        arabicExample: 'أراك لاحقاً، اعتن بنفسك!',
        audioUrl: 'https://example.com/seeyoulater.mp3',
      ),
    ];
    _saveDailyWords();
  }

  void _saveDailyWords() {
    final wordsJson = json.encode(_allWords.map((w) => w.toJson()).toList());
    _prefs.setString('dailyWords', wordsJson);
  }

  Future<void> loadMoreWords() async {
    if (!_hasMoreWords || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _loadNextPage();

    _isLoading = false;
    notifyListeners();
  }

  void _loadNextPage() {
    final startIndex = (_currentPage - 1) * wordsPerPage;
    final endIndex = startIndex + wordsPerPage;

    if (startIndex >= _allWords.length) {
      _hasMoreWords = false;
      return;
    }

    final newWords = _allWords.sublist(
      startIndex,
      endIndex > _allWords.length ? _allWords.length : endIndex,
    );

    _displayedWords = [..._displayedWords, ...newWords];
    _currentPage++;
    _hasMoreWords = endIndex < _allWords.length;
  }

  void markWordAsLearned(Word word) {
    final index = _allWords.indexWhere(
      (w) => w.englishWord == word.englishWord,
    );
    if (index != -1) {
      _allWords[index].isLearned = true;
      _saveDailyWords();
      _updateStreak();
    }
  }

  void _updateStreak() {
    final now = DateTime.now();
    final lastDateStr = _prefs.getString('lastLearnedDate');
    DateTime lastLearnedDate = now;

    if (lastDateStr != null) {
      lastLearnedDate = DateTime.parse(lastDateStr);
    }

    final difference = now.difference(lastLearnedDate).inDays;
    int currentStreak = _prefs.getInt('streak') ?? 0;

    if (difference == 1) {
      currentStreak++;
    } else if (difference > 1) {
      currentStreak = 1;
    }

    _prefs.setInt('streak', currentStreak);
    _prefs.setString('lastLearnedDate', now.toIso8601String());
    notifyListeners();
  }
}
