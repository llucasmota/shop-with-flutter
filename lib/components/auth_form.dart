// ignore_for_file: prefer_final_fields

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

/// Adicionamos o [SingleTickerProviderStateMixin] para que este componente
/// seja capaz de executar animções
class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  Map<String, String> _authData = {'email': '', 'password': ''};
  AuthMode _authMode = AuthMode.login;

  // AnimationController? _controller;
  // Animation<Size>? _heightAnimation;

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));

    /// Size(width, heigh)
    /// Trabalhamos a altura nessa animacão, portanto informamos o inicio(310) e o fim(400)
    ///
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    /// sem isso a animação não funciona
    // _heightAnimation?.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ocorreu um Erro'),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'))
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
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 330 : 400,
        // height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _passwordController,
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
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (_password) {
                            final password = _password ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas informadas não conferem.';
                            }
                            return null;
                          },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(_isLogin() ? 'ENTRAR' : 'REGISTRAR'),
                ),
              const Spacer(),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: switchAuthMode,
                  child: Text(
                    _isLogin() ? 'DESEJA SE REGISTRAR' : 'JÁ POSSUI CONTA?',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
