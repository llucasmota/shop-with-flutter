import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constantes.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  void _toggleFavorite(String token) {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token) async {
    _toggleFavorite(token);

    final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json?auth=$token'),
        body: jsonEncode({"isFavorite": isFavorite}));

    if (response.statusCode >= 400) {
      _toggleFavorite(token);
      throw HttpException(
        message: !isFavorite
            ? 'Não foi possível favoritar'
            : 'Não foi possível remover dos favoritos',
        statusCode: response.statusCode,
      );
    }
  }
}
