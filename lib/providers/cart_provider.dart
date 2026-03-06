import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  final List<ComboModel> selectedCombos;

  CartItem({
    required this.product,
    this.quantity = 1,
    List<ComboModel>? selectedCombos,
  }) : selectedCombos = selectedCombos ?? [];

  double get totalPrice {
    final basePrice = product.discountPrice ?? product.price;
    final comboExtra = selectedCombos.fold<double>(
      0,
      (sum, c) => sum + c.extraPrice,
    );
    return (basePrice + comboExtra) * quantity;
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get itemCount =>
      _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold<double>(0, (sum, item) => sum + item.totalPrice);

  void addItem(ProductModel product, {List<ComboModel>? combos}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product, selectedCombos: combos);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
