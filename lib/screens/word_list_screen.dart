import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/providers/word_provider.dart';
import 'package:wordly/widgets/word_card.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Words'), centerTitle: true),
      body: Consumer<WordProvider>(
        builder: (context, wordProvider, child) {
          return ListView.builder(
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
                        style: TextStyle(color: Colors.grey, fontSize: 16),
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
                              onPressed: () => wordProvider.loadMoreWords(),
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
          );
        },
      ),
    );
  }
}
