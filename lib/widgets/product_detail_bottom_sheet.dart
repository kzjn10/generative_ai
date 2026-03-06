import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

void showProductDetail(
  BuildContext context,
  ProductModel product,
  List<ComboModel> combos,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ProductDetailBottomSheet(product: product, combos: combos),
  );
}

class ProductDetailBottomSheet extends StatefulWidget {
  final ProductModel product;
  final List<ComboModel> combos;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.combos,
  });

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  final Set<String> _selectedComboIds = {};

  List<ComboModel> get _selectedCombos =>
      widget.combos.where((c) => _selectedComboIds.contains(c.id)).toList();

  double get _totalExtra =>
      _selectedCombos.fold<double>(0, (sum, c) => sum + c.extraPrice);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final hasDiscount = product.discountPrice != null;
    final basePrice = product.discountPrice ?? product.price;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Hero(
                    tag: product.heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${basePrice.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (hasDiscount)
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    product.desc,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  // Combos
                  if (widget.combos.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Add extras',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.combos.map((combo) {
                      final selected = _selectedComboIds.contains(combo.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Material(
                          color: selected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  _selectedComboIds.remove(combo.id);
                                } else {
                                  _selectedComboIds.add(combo.id);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      combo.title,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                  Text(
                                    '+\$${combo.extraPrice.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Add to cart button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  context.read<CartProvider>().addItem(
                    product,
                    combos: _selectedCombos,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  'Add to Cart — \$${(basePrice + _totalExtra).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
