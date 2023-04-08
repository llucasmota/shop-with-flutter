import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/utils/constantes.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId; // localId
  DateTime? _expiresIn;

  bool get isAuthenticated {
    final tokenIsValid = _expiresIn?.isAfter(DateTime.now()) ?? false;
    return _token != null && tokenIsValid;
  }

  String? get token => isAuthenticated ? _token : null;

  String? get email => isAuthenticated ? _email : null;

  String? get userId => isAuthenticated ? _userId : null;

  Future<void> signup(String email, String password) async {
    await _autheticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    await _autheticate(email, password, "signInWithPassword");
  }

  Future<void> _autheticate(
      String email, String password, String urlFragment) async {
    final url = Constants.AUTH_URL.replaceFirst("urlFragment", urlFragment);
    final response = await post(Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiresIn =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      print(
          'token: $token , email: $email , uid: $userId , expiesIn: $_expiresIn , isAuthenticated: $isAuthenticated');

      super.notifyListeners();
    }
  }
}
