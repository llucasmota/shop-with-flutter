import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

enum BotaoSubmit { ENTRAR, REGISTRAR }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, String> _authData = {'email': '', 'password': ''};

  AuthMode _authMode = AuthMode.Login;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _toggleMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ocorreu um Erro'),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar'))
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin()) {
        await auth.login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        await auth.signup(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() {
      _isLoading = false;
    });

    print('chamei');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) => _authData['email'] = email ?? '',
              controller: emailController,
              validator: (_email) {
                final email = _email ?? '';
                if (email.trim().isEmpty || !email.contains('@')) {
                  return 'Informe um e-mail válido';
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: passwordController,
              maxLength: 10,
              onSaved: (pass) => _authData['password'] = pass ?? '',
              validator: (passwordValue) {
                final pass = passwordValue ?? '';
                if (pass.isEmpty || pass.length < 5) {
                  return 'Senha não pode ser vazia ou menor que 5';
                }
                return null;
              },
            ),
            if (_isSignup())
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                maxLength: 10,
                validator: (_password) {
                  final pass = _password ?? '';
                  if (pass != passwordController.text) {
                    return 'Senhas informadas não conferem';
                  }
                },
              ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading)
              const CircularProgressIndicator.adaptive()
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                ),
                onPressed: _submit,
                child: Text(_isLogin() ? 'ENTRAR' : 'REGISTRAR'),
              ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: _toggleMode,
                child: Text(
                  _isLogin() ? 'DESEJA SE REGISTRAR' : 'JÁ POSSUI CONTA?',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ))
          ]),
        ),
      ),
    );
  }
}
