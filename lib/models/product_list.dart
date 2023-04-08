import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constantes.dart';

class ProductList with ChangeNotifier {
  final String _token;
  List<Product> _items = [];

  bool _showFavoriteOnly = false;

  ProductList(this._token, this._items);

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
          Uri.parse(
              '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
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

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach(
      (productId, productData) {
        Map<String, dynamic> value = {'id': productId, ...productData};
        _items.add(Product.fromJson(value)
            //   Product(
            //       id: productId.toString(),
            //       name: productData['name'],
            //       description: productData['description'],
            //       price: productData['price'],
            //       imageUrl: productData['imageUrl'],
            //       isFavorite: productData['isFavorite']),
            );
      },
    );
    notifyListeners();
    print(jsonDecode(response.body));
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite
        }));

    final id = jsonDecode(response.body)['name'];
    Map<String, dynamic> value = {'id': id, ...product.toJson()};

    _items.add(Product.fromJson(value));
    notifyListeners();
  }

  Future<void> removeProductByProductId(Product product) async {
    int findIndex = _items.indexWhere((prd) => prd.id == product.id);

    if (findIndex >= 0) {
      _items.remove(product);
      super.notifyListeners();
      final response = await http.delete(Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'));
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
