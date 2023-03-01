import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        imageUrl: data['imageUrl'] as String);

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void updateProduct(Product product) {
    // tem um indice válido?

    int index = _items.indexWhere((prd) => prd.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      super.notifyListeners();
    }
  }

  void addProduct(Product product) {
    _items.add(product);
    super.notifyListeners();
  }

  int get itemsCount => _items.length;
}
