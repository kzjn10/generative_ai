import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ComboList extends StatelessWidget {
  final List<ComboModel> combos;

  const ComboList({super.key, required this.combos});

  @override
  Widget build(BuildContext context) {
    if (combos.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
          child: Text(
            '🔥 Suggested Combos',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: combos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final combo = combos[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          '${combo.title}  +\$${combo.extraPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
