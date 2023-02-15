import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void removeASingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity == 1) {
      removeItem(productId);
    } else {
      _items.update(productId, (prd) {
        return CartItem(
            id: prd.id,
            name: prd.name,
            price: prd.price,
            quantity: prd.quantity - 1,
            productId: productId);
      });
    }
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (prd) => CartItem(
            productId: prd.productId,
            name: prd.name,
            quantity: prd.quantity + 1,
            price: prd.price,
            id: prd.id),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            productId: product.id,
            name: product.name,
            quantity: 1,
            price: product.price,
            id: Random().nextDouble().toString()),
      );
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
}
