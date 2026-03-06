class ProductModel {
  final String id;
  final String title;
  final String desc;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final String heroTag;

  const ProductModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    String? heroTag,
  }) : heroTag = heroTag ?? 'product_hero_$id';

  /// Whether the product currently has a discount applied.
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// The effective selling price (discount if available, otherwise full price).
  double get effectivePrice => discountPrice ?? price;

  /// Discount percentage (0 if no discount).
  int get discountPercent =>
      hasDiscount ? ((1 - discountPrice! / price) * 100).round() : 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return ProductModel(
      id: id,
      title: json['title'] as String,
      desc: json['desc'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      imageUrl: json['image_url'] as String,
      heroTag: json['hero_tag'] as String? ?? 'product_hero_$id',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'desc': desc,
    'price': price,
    'discount_price': discountPrice,
    'image_url': imageUrl,
    'hero_tag': heroTag,
  };
}

class ComboModel {
  final String id;
  final String title;
  final double extraPrice;

  const ComboModel({
    required this.id,
    required this.title,
    required this.extraPrice,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      id: json['id'] as String,
      title: json['title'] as String,
      extraPrice: (json['extra_price'] as num).toDouble(),
    );
  }
}

enum DisplayType { list, grid, single }

class GenerativeUiResponse {
  final DisplayType displayType;
  final List<ProductModel> products;
  final List<ComboModel> combos;

const GenerativeUiResponse({
    required this.displayType,
    required this.products,
    required this.combos,
  });

  factory GenerativeUiResponse.fromJson(Map<String, dynamic> json) {
    final typeStr = json['display_type'] as String;
    final displayType = DisplayType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => DisplayType.list,
    );

    return GenerativeUiResponse(
      displayType: displayType,
      products: (json['products'] as List<dynamic>)
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      combos: (json['combos'] as List<dynamic>? ?? [])
          .map((c) => ComboModel.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
