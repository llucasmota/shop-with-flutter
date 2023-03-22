import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constantes.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  bool _showFavoriteOnly = false;

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

  Future<void> updateProduct(Product product) async {
    // tem um indice válido?

    int index = _items.indexWhere((prd) => prd.id == product.id);

    if (index >= 0) {
      final response = await http.patch(
          Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
          }));

      _items[index] = product;
      super.notifyListeners();
    }

    return Future.value();
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response =
        await http.get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach(
      (productId, productData) {
        _items.add(
          Product(
              id: productId.toString(),
              name: productData['name'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: productData['isFavorite']),
        );
      },
    );
    notifyListeners();
    print(jsonDecode(response.body));
  }

  Future<void> addProduct(Product product) async {
    final response =
        await http.post(Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
            body: jsonEncode({
              "name": product.name,
              "description": product.description,
              "imageUrl": product.imageUrl,
              "price": product.price,
              "isFavorite": product.isFavorite
            }));

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl));
    notifyListeners();
  }

  Future<void> removeProductByProductId(Product product) async {
    int findIndex = _items.indexWhere((prd) => prd.id == product.id);

    if (findIndex >= 0) {
      _items.remove(product);
      super.notifyListeners();
      final response = await http.delete(
          Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'));
      if (response.statusCode >= 400) {
        _items.insert(findIndex, product);
        super.notifyListeners();
        throw HttpException(
            message: 'Não foi possível excluir produto',
            statusCode: response.statusCode);
      }
    }
  }

  int get itemsCount => _items.length;
}
