import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wordly/providers/language_provider.dart';

class Message {
  final String content;
  final bool isUser;
  final String timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  bool _isTyping = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;
  static const String _systemPrompt = '''
You are an AI language tutor helping users learn English and Arabic. Your role is to:
1. Provide clear, concise explanations of language concepts
2. Correct mistakes gently and explain why they were incorrect
3. Use simple language appropriate for language learners
4. Include examples to illustrate points
5. Encourage practice and engagement
6. Respond in the same language as the user's message
7. Focus on practical, everyday language usage
8. Break down complex concepts into manageable parts
9. Provide cultural context when relevant
10. Maintain a supportive and encouraging tone

Remember to:
- Keep responses concise and focused
- Use proper grammar and spelling
- Include translations when helpful
- Encourage active learning
- Provide positive reinforcement
''';

  ChatProvider() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemma-3-1b-it',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
    // Initialize chat with system prompt
    _chat.sendMessage(Content.text(_systemPrompt));
  }

  List<Message> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String content) async {
    final timestamp = DateFormat('HH:mm').format(DateTime.now());

    // Add user message
    _messages.add(Message(
      content: content,
      isUser: true,
      timestamp: timestamp,
    ));
    notifyListeners();

    // Show typing indicator
    _isTyping = true;
    notifyListeners();

    try {
      // Enhance the prompt with context about language learning
      final enhancedPrompt = '''
As a language learning tutor, please help with the following:
$content

Remember to:
- Keep your response focused on language learning
- Provide clear explanations
- Include examples if helpful
- Correct any language mistakes gently
- Respond in the same language as the user's message
''';

      // Send message to Gemini
      final response = await _chat.sendMessage(Content.text(enhancedPrompt));

      // Add AI response
      _messages.add(Message(
        content: response.text ?? 'Sorry, I could not process your request.',
        isUser: false,
        timestamp: DateFormat('HH:mm').format(DateTime.now()),
      ));
    } catch (e) {
      print(e);
      // Handle errors
      _messages.add(Message(
        content:
            'Sorry, there was an error processing your request. Please try again.',
        isUser: false,
        timestamp: DateFormat('HH:mm').format(DateTime.now()),
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _chat = _model.startChat(); // Reset chat session
    // Re-initialize with system prompt
    _chat.sendMessage(Content.text(_systemPrompt));
    notifyListeners();
  }
}
