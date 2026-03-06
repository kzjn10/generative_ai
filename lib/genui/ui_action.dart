import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_detail_bottom_sheet.dart';

/// Abstract interface for UI actions triggered from product cards and lists.
abstract class UiAction {
  /// Called when the user taps "Add to Cart".
  void onAddToCart(
    BuildContext context,
    ProductModel product, {
    List<ComboModel> combos,
  });

  /// Called when the user taps a product to see its details.
  void onShowDetails(
    BuildContext context,
    ProductModel product, {
    List<ComboModel> combos,
  });
}

/// Default implementation that uses [CartProvider] and the modal bottom sheet.
class DefaultUiAction implements UiAction {
  const DefaultUiAction();

  @override
  void onAddToCart(
    BuildContext context,
    ProductModel product, {
    List<ComboModel> combos = const [],
  }) {
    context.read<CartProvider>().addItem(product, combos: combos);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void onShowDetails(
    BuildContext context,
    ProductModel product, {
    List<ComboModel> combos = const [],
  }) {
    showProductDetail(context, product, combos);
  }
}
