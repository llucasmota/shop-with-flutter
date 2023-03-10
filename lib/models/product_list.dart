import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;
  static const _baseUrl =
      'https://shop-cod3r-82fbc-default-rtdb.firebaseio.com/';

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        imageUrl: data['imageUrl'] as String);

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) {
    // tem um indice válido?

    int index = _items.indexWhere((prd) => prd.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      super.notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product product) {
    final future = http.post(Uri.parse('$_baseUrl/products.json'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "image": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite
        }));

    return future.then<void>((response) {
      final id = jsonDecode(response.body)['name'];
      _items.add(Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));
      super.notifyListeners();
    });
  }

  void removeProductByProductId(String productId) {
    if (_items.indexWhere((prd) => prd.id == productId) >= 0) {
      _items.removeWhere((prd) => prd.id == productId);
      super.notifyListeners();
    }
  }

  int get itemsCount => _items.length;
}
