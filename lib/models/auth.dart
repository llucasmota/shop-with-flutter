import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/data/my_store.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/utils/constantes.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId; // localId
  DateTime? _expiresIn;
  Timer? _logoutTimer;

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

  Future<void> tryAutoLogin() async {
    if (isAuthenticated) return;
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiresIn']);
    if (expiryDate.isBefore(DateTime.now())) return; // token expirado

    /// Token válida com baase em [userData]
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiresIn = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null; // localId
    _expiresIn = null;
    _clearLogoutTimer();
    notifyListeners();
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiresIn?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
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

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiresIn': _expiresIn!.toIso8601String(),
      });

      print(
          'token: $token , email: $email , uid: $userId , expiesIn: $_expiresIn , isAuthenticated: $isAuthenticated');
      _autoLogout();
      super.notifyListeners();
    }
  }
}
