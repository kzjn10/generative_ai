import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/product_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final GenerativeUiResponse? uiResponse;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.uiResponse,
  });
}

const _geminiModel = String.fromEnvironment('GEMINI_MODEL');
const _apiKey = String.fromEnvironment('GEMINI_KEY');

const _systemInstruction = '''
You are a helpful and friendly store assistant at Smart Convenience, a modern convenience store.
Your personality is upbeat, knowledgeable, and concise — like a great in-store employee.

Whenever you respond to a customer, you MUST call the respond_with_products function.
Never reply with plain text only — always include a product UI response.

You are responsible for generating realistic product data (id, title, desc, price, image_url, combos) that fits the customer request. Use real-looking convenience store product names, short descriptions, and prices. For image_url, use relevant Unsplash photo URLs in the format: https://images.unsplash.com/photo-<id>?w=400

## Response Strategy
- drinks, beverages, candy, chips, snacks → display_type: "list"
- food, eat, breakfast, bite, hot food, coffee, snack bar → display_type: "grid"
- deal, featured, recommendation, "just one thing", specific single item → display_type: "single"
- greeting or general question → display_type: "list", show a variety of popular items
''';

final _respondWithProductsTool = FunctionDeclaration(
  'respond_with_products',
  'Respond to the customer with a product UI and a friendly text message.',
  Schema.object(
    properties: {
      'message': Schema.string(
        description: 'A short, friendly text response to the customer.',
      ),
      'display_type': Schema.enumString(
        enumValues: ['list', 'grid', 'single'],
        description:
            'list = vertical list of drinks/snacks, grid = 2-col food grid, single = featured deal.',
      ),
      'products': Schema.array(
        description: 'Products to display.',
        items: Schema.object(
          properties: {
            'id': Schema.string(description: 'Product id'),
            'title': Schema.string(description: 'Product name'),
            'desc': Schema.string(description: 'Short description'),
            'price': Schema.number(description: 'Regular price'),
            'discount_price': Schema.number(
              description: 'Sale price, omit if no discount',
              nullable: true,
            ),
            'image_url': Schema.string(description: 'Full image URL'),
          },
        ),
      ),
      'combos': Schema.array(
        description: 'Optional add-on combos.',
        items: Schema.object(
          properties: {
            'id': Schema.string(description: 'Combo id'),
            'title': Schema.string(description: 'Combo label, e.g. + Big Gulp'),
            'extra_price': Schema.number(description: 'Additional price'),
          },
        ),
      ),
    },
    requiredProperties: ['message', 'display_type', 'products'],
  ),
);

class ChatProvider extends ChangeNotifier {
  ChatProvider() {
    _model = GenerativeModel(
      model: _geminiModel,
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemInstruction),
      tools: [Tool(functionDeclarations: [_respondWithProductsTool])],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.any,
          allowedFunctionNames: {'respond_with_products'},
        ),
      ),
    );
    _chat = _model.startChat();
    _messages.add(
      const ChatMessage(
        text: 'Welcome to Smart Convenience! 🏪\nHow can I help you today?',
        isUser: false,
      ),
    );
  }

  late final GenerativeModel _model;
  late final ChatSession _chat;

  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;

  Future<void> sendMessage(String text) async {
    _messages.add(ChatMessage(text: text, isUser: true));
    _messages.add(const ChatMessage(text: '', isUser: false, isLoading: true));
    _isProcessing = true;
    notifyListeners();

    try {
      final response = await _chat.sendMessage(Content.text(text));
      _handleResponse(response);
    } catch (e) {
      _messages.removeLast();
      _messages.add(
        ChatMessage(
          text: 'Sorry, something went wrong.\n$e',
          isUser: false,
        ),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _handleResponse(GenerateContentResponse response) {
    final calls = response.functionCalls.toList();
    if (calls.isNotEmpty) {
      final call = calls.first;
      if (call.name == 'respond_with_products') {
        final args = call.args;
        final message = args['message'] as String? ?? '';
        try {
          final uiJson = <String, dynamic>{
            'display_type': args['display_type'],
            'products': args['products'],
            'combos': args['combos'] ?? [],
          };
          final uiResponse = GenerativeUiResponse.fromJson(uiJson);
          _messages.removeLast();
          _messages.add(
            ChatMessage(text: message, isUser: false, uiResponse: uiResponse),
          );
          return;
        } catch (e) {
          _messages.removeLast();
          _messages.add(ChatMessage(text: message, isUser: false));
          return;
        }
      }
    }
    final text = response.text ?? '';
    _messages.removeLast();
    _messages.add(ChatMessage(text: text, isUser: false));
  }

}
