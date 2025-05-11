class Word {
  final String englishWord; // The English word to learn
  final String arabicTranslation; // The Arabic translation
  final String englishExample; // Example sentence in English
  final String arabicExample; // Example sentence in Arabic
  final String audioUrl; // URL for pronunciation
  bool isLearned;

  Word({
    required this.englishWord,
    required this.arabicTranslation,
    required this.englishExample,
    required this.arabicExample,
    required this.audioUrl,
    this.isLearned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'englishWord': englishWord,
      'arabicTranslation': arabicTranslation,
      'englishExample': englishExample,
      'arabicExample': arabicExample,
      'audioUrl': audioUrl,
      'isLearned': isLearned,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      englishWord: json['englishWord'],
      arabicTranslation: json['arabicTranslation'],
      englishExample: json['englishExample'],
      arabicExample: json['arabicExample'],
      audioUrl: json['audioUrl'],
      isLearned: json['isLearned'] ?? false,
    );
  }
}
