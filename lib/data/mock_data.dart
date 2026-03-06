import '../models/product_model.dart';

/// Pre-built simulated JSON responses for each display type.
/// Uses popular convenience store items.

final Map<String, dynamic> _popularProducts = {
  "list": {
    "display_type": "list",
    "products": [
      {
        "id": "p01",
        "title": "Red Bull Energy Drink",
        "desc": "Vitalizes Body and Mind. 8.4 fl oz can.",
        "price": 2.99,
        "discount_price": 2.49,
        "image_url":
            "https://images.unsplash.com/photo-1622543925917-763c34d1a86e?w=400",
      },
      {
        "id": "p02",
        "title": "Doritos Nacho Cheese",
        "desc": "Classic nacho cheese flavored tortilla chips.",
        "price": 4.99,
        "image_url":
            "https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=400",
      },
      {
        "id": "p03",
        "title": "Coca-Cola Classic",
        "desc": "Refreshing, crisp taste you know and love. 20 oz bottle.",
        "price": 2.29,
        "image_url":
            "https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400",
      },
      {
        "id": "p04",
        "title": "Snickers Candy Bar",
        "desc":
            "Packed with roasted peanuts, nougat, caramel and milk chocolate.",
        "price": 1.79,
        "discount_price": 1.29,
        "image_url":
            "https://images.unsplash.com/photo-1621508654686-809f23efdabc?w=400",
      },
    ],
    "combos": [
      {"id": "c1", "title": "+ 2nd Candy Bar", "extra_price": 1.00},
      {"id": "c2", "title": "+ Small Slushie", "extra_price": 1.49},
    ],
  },
  "grid": {
    "display_type": "grid",
    "products": [
      {
        "id": "p05",
        "title": "Spicy Bite Taquitos",
        "desc": "Rolled corn tortillas filled with spicy chicken and cheese.",
        "price": 3.49,
        "discount_price": 2.99,
        "image_url":
            "https://images.unsplash.com/photo-1599974579688-8fadcd26df48?w=400",
      },
      {
        "id": "p06",
        "title": "Beef Jerky Original",
        "desc": "Slow cooked and hardwood smoked savory meat snack.",
        "price": 6.99,
        "image_url":
            "https://images.unsplash.com/photo-1599587413695-17e94b2bd3db?w=400",
      },
      {
        "id": "p07",
        "title": "Bagel with Cream Cheese",
        "desc": "Freshly baked bagel served with rich cream cheese.",
        "price": 2.99,
        "image_url":
            "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=400",
      },
      {
        "id": "p08",
        "title": "Iced Coffee Mocha",
        "desc": "Premium coffee shaken with ice and dark chocolate syrup.",
        "price": 3.99,
        "discount_price": 3.49,
        "image_url":
            "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400",
      },
    ],
    "combos": [
      {"id": "c3", "title": "+ Extra Shot", "extra_price": 0.99},
      {"id": "c4", "title": "+ Hash Brown", "extra_price": 1.29},
    ],
  },
  "single": {
    "display_type": "single",
    "products": [
      {
        "id": "p09",
        "title": "Quarter Pound Hot Dog",
        "desc":
            "100% all-beef hot dog on a fresh bakery bun. Includes your choice of condiments at the bar.",
        "price": 2.49,
        "discount_price": 1.99,
        "image_url":
            "https://images.unsplash.com/photo-1619740455993-9e612b1af08a?w=400",
      },
    ],
    "combos": [
      {"id": "c5", "title": "+ Big Gulp Drink", "extra_price": 1.50},
      {"id": "c6", "title": "+ Large Chips", "extra_price": 2.00},
      {"id": "c7", "title": "+ Melted Cheese", "extra_price": 0.75},
    ],
  },
};

GenerativeUiResponse mockListResponse() =>
    GenerativeUiResponse.fromJson(_popularProducts['list']);

GenerativeUiResponse mockGridResponse() =>
    GenerativeUiResponse.fromJson(_popularProducts['grid']);

GenerativeUiResponse mockSingleResponse() =>
    GenerativeUiResponse.fromJson(_popularProducts['single']);
