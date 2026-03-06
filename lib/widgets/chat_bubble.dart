import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/chat_provider.dart';
import 'generative_ui_renderer.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (message.isLoading) {
      return _buildLoadingBubble(theme);
    }

    if (message.isUser) {
      return _buildUserBubble(theme);
    }

    return _buildBotBubble(context, theme);
  }

  Widget _buildUserBubble(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 12, left: 60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBotBubble(BuildContext context, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot avatar + label
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.tertiary,
                        theme.colorScheme.primary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Smart Assistant',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Text bubble
            if (message.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Text(
                  message.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

            if (message.uiResponse != null) ...[
              const SizedBox(height: 10),
              GenerativeUiRenderer(response: message.uiResponse!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.tertiary,
                        theme.colorScheme.primary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Smart Assistant',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Shimmer.fromColors(
              baseColor: theme.colorScheme.surfaceContainerHighest,
              highlightColor: theme.colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 220,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 260,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
