import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product_model.dart';
import '../genui/ui_action.dart';
import 'product_detail_bottom_sheet.dart';

/// Optimized product card with [AutomaticKeepAliveClientMixin] to prevent
/// re-rendering during scroll, Hero transitions via [ProductModel.heroTag],
/// and optional [UiAction] for consistent action handling.
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final List<ComboModel> combos;
  final bool isFeatured;
  final UiAction? action;

  const ProductCard({
    super.key,
    required this.product,
    this.combos = const [],
    this.isFeatured = false,
    this.action,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final product = widget.product;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: widget.isFeatured
            ? _buildFeatured(context, product)
            : _buildCompact(context, product),
      ),
    );
  }

  void _onTap(BuildContext context) {
    final action = widget.action;
    if (action != null) {
      action.onShowDetails(context, widget.product, combos: widget.combos);
    } else {
      showProductDetail(context, widget.product, widget.combos);
    }
  }

  // ─── Featured layout ──────────────────────────────────────────

  Widget _buildFeatured(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero image
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildHeroImage(product),
              if (product.hasDiscount) _buildDiscountBadge(product),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              _buildPriceRow(context, product),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Compact (grid) layout ────────────────────────────────────

  Widget _buildCompact(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildHeroImage(product),
              if (product.hasDiscount) _buildDiscountBadge(product),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _buildPriceRow(context, product),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Shared sub-widgets ───────────────────────────────────────

  Widget _buildHeroImage(ProductModel product) {
    return Hero(
      tag: product.heroTag,
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
          child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(ProductModel product) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '-${product.discountPercent}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '\$${product.effectivePrice.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const Spacer(),
        // Quick add-to-cart button
        Material(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              final action = widget.action;
              if (action != null) {
                action.onAddToCart(context, product, combos: widget.combos);
              } else {
                // Fallback: use DefaultUiAction
                const DefaultUiAction().onAddToCart(
                  context,
                  product,
                  combos: widget.combos,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
