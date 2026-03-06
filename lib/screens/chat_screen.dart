import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/chat_bubble.dart';
import 'cart_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    _controller.clear();
    setState(() => _isSending = true);

    _scrollToBottom();
    await context.read<ChatProvider>().sendMessage(text);
    _scrollToBottom();

    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Convenience',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Cart icon with badge
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Consumer<CartProvider>(
              builder: (context, cart, _) => IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                icon: Badge(
                  isLabelVisible: cart.itemCount > 0,
                  label: Text('${cart.itemCount}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chat, _) {
                _scrollToBottom();
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: chat.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: chat.messages[index]);
                  },
                );
              },
            ),
          ),

          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              8,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isSending ? null : _handleSend,
                    icon: Icon(
                      Icons.send_rounded,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
