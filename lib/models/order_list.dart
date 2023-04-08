import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constantes.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];
  final String _token;

  OrderList(this._token, this._items);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
        Uri.parse('${Constants.ORDERS_BASE_URL}.json?auth=$_token'),
        body: jsonEncode({
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        }));

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http
        .get(Uri.parse('${Constants.ORDERS_BASE_URL}.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    print(jsonDecode(response.body));
    data.forEach(
      (orderId, ordersData) {
        items.add(Order(
            id: orderId.toString(),
            date: DateTime.parse(ordersData['date']),
            products: (ordersData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      productId: item['productId'],
                      name: item['name'],
                      quantity: item['quantity'],
                      price: item['price'],
                      id: item['id']),
                )
                .toList(),
            total: ordersData['total']));
      },
    );
    _items = items.reversed.toList();
    notifyListeners();
  }
}
