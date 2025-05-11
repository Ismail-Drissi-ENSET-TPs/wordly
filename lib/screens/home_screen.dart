import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/l10n/app_localizations.dart';
import 'package:wordly/providers/language_provider.dart';
import 'package:wordly/providers/word_provider.dart';
import 'package:wordly/widgets/word_card.dart';
import 'package:wordly/widgets/streak_counter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Wordly'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.translate, color: Colors.white, size: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<WordProvider>(
        builder: (context, wordProvider, child) {
          return Column(
            children: [
              const StreakCounter(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: wordProvider.displayedWords.length + 1,
                  itemBuilder: (context, index) {
                    if (index == wordProvider.displayedWords.length) {
                      if (!wordProvider.hasMoreWords) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No more words to load',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              wordProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                    onPressed:
                                        () => wordProvider.loadMoreWords(),
                                    child: const Text('Load More Words'),
                                  ),
                        ),
                      );
                    }

                    final word = wordProvider.displayedWords[index];
                    return WordCard(
                      word: word,
                      onLearned: () => wordProvider.markWordAsLearned(word),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
