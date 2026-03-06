import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  cart.clearCart();
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chat with our assistant to find great deals!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final items = cart.items.values.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item.product;
                    final hasDiscount = product.discountPrice != null;
                    final unitPrice = product.discountPrice ?? product.price;

                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.fastfood,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${unitPrice.toStringAsFixed(2)}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (hasDiscount) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (item.selectedCombos.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      children: item.selectedCombos
                                          .map(
                                            (c) => Chip(
                                              label: Text(
                                                c.title,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Quantity controls
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 36,
                                        height: 32,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 18,
                                          onPressed: () =>
                                              cart.addItem(product),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        width: 36,
                                        height: 32,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 18,
                                          onPressed: () =>
                                              cart.decrementItem(product.id),
                                          icon: const Icon(Icons.remove),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Total bar
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  16 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '\$${cart.totalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Checkout coming soon! 🚀'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
