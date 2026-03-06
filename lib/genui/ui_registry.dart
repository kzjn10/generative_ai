import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'ui_action.dart';

/// Signature for a builder that creates a widget for a given [GenerativeUiResponse].
typedef UiBuilder =
    Widget Function(GenerativeUiResponse response, UiAction action);

/// Registry that maps [DisplayType] to a [UiBuilder].
///
/// Pre-registers built-in builders for `list`, `grid`, and `single`.
/// Call [registerBuilder] to add or override a display type at runtime.
class UiRegistry {
  UiRegistry._();

  static final UiRegistry instance = UiRegistry._();

  final Map<DisplayType, UiBuilder> _builders = {};

  /// Must be called once at app startup to populate default builders.
  void init() {
    _builders[DisplayType.list] = _buildListView;
    _builders[DisplayType.grid] = _buildGridView;
    _builders[DisplayType.single] = _buildSingleView;
  }

  /// Register (or override) a builder for [type].
  void registerBuilder(DisplayType type, UiBuilder builder) {
    _builders[type] = builder;
  }

  /// Build the widget for [response], falling back to a list view if
  /// no builder is registered for the display type.
  Widget build(GenerativeUiResponse response, UiAction action) {
    final builder = _builders[response.displayType] ?? _buildListView;
    return builder(response, action);
  }

  // ─── Built-in builders ────────────────────────────────────────────

  static Widget _buildListView(GenerativeUiResponse response, UiAction action) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: response.products.length,
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final product = response.products[index];
        return SizedBox(
          height: 120,
          child: _ListProductTile(
            product: product,
            combos: response.combos,
            action: action,
          ),
        );
      },
    );
  }

  static Widget _buildGridView(GenerativeUiResponse response, UiAction action) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.78,
      children: response.products
          .map(
            (p) => ProductCard(
              product: p,
              combos: response.combos,
              action: action,
            ),
          )
          .toList(),
    );
  }

  static Widget _buildSingleView(
    GenerativeUiResponse response,
    UiAction action,
  ) {
    final product = response.products.first;
    return ProductCard(
      product: product,
      combos: response.combos,
      isFeatured: true,
      action: action,
    );
  }
}

// ─── Horizontal list tile (used by the list builder) ──────────────

class _ListProductTile extends StatefulWidget {
  final ProductModel product;
  final List<ComboModel> combos;
  final UiAction action;

  const _ListProductTile({
    required this.product,
    required this.combos,
    required this.action,
  });

  @override
  State<_ListProductTile> createState() => _ListProductTileState();
}

class _ListProductTileState extends State<_ListProductTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final product = widget.product;

    return GestureDetector(
      onTap: () =>
          widget.action.onShowDetails(context, product, combos: widget.combos),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Product image with hero
            SizedBox(
              width: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.heroTag,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (product.hasDiscount) _buildBadge(),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.desc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${product.effectivePrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
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
                        // Quick add-to-cart
                        Material(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => widget.action.onAddToCart(
                              context,
                              product,
                              combos: widget.combos,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 6,
      left: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '-${widget.product.discountPercent}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
