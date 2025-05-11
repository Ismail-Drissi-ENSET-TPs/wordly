import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/providers/quiz_provider.dart';
import 'package:wordly/providers/word_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    // Generate quiz when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wordProvider = Provider.of<WordProvider>(context, listen: false);
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.generateQuiz(wordProvider.displayedWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Consumer2<QuizProvider, WordProvider>(
        builder: (context, quizProvider, wordProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.isQuizComplete) {
            return _buildQuizComplete(quizProvider);
          }

          final question = quizProvider.currentQuestion;
          if (question == null) {
            return const Center(child: Text('No questions available'));
          }

          return Column(
            children: [
              _buildProgressBar(quizProvider),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'What is the Arabic translation of:',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            question.word.englishWord,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...question.options.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OutlinedButton(
                            onPressed:
                                () => quizProvider.answerQuestion(entry.key),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: theme.colorScheme.surface,
                            ),
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(QuizProvider quizProvider) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: quizProvider.progress,
            backgroundColor: theme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${quizProvider.currentQuestionIndex + 1} of ${quizProvider.questions.length}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizComplete(QuizProvider quizProvider) {
    final theme = Theme.of(context);
    final score = quizProvider.score;
    final total = quizProvider.questions.length;
    final percentage = (score / total * 100).round();

    Color resultColor;
    IconData resultIcon;
    String resultMessage;
    String resultSubtitle;

    if (percentage >= 80) {
      resultColor = theme.colorScheme.primary;
      resultIcon = Icons.emoji_events;
      resultMessage = 'Excellent!';
      resultSubtitle = 'You\'re a language master!';
    } else if (percentage >= 60) {
      resultColor = theme.colorScheme.secondary;
      resultIcon = Icons.sentiment_satisfied;
      resultMessage = 'Good job!';
      resultSubtitle = 'Keep up the good work!';
    } else {
      resultColor = theme.colorScheme.error;
      resultIcon = Icons.sentiment_dissatisfied;
      resultMessage = 'Keep practicing!';
      resultSubtitle = 'Every attempt is a step forward';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(resultIcon, size: 64, color: resultColor),
            ),
            const SizedBox(height: 24),
            Text(
              resultMessage,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resultSubtitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Your Score', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      '$score/$total',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: resultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final wordProvider = Provider.of<WordProvider>(
                  context,
                  listen: false,
                );
                quizProvider.generateQuiz(wordProvider.displayedWords);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
