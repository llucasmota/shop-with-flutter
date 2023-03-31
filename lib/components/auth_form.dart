import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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

  AuthMode _authMode = AuthMode.Login;

  void _submit() {
    print('Chame aqui');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Map<String, String> _authData = {'email': '', 'senha': ''};
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 320,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
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
              onSaved: (senha) => _authData['senha'] = senha ?? '',
              validator: (passwordValue) {
                final pass = passwordValue ?? '';
                if (pass.isEmpty || pass.length < 5) {
                  return 'Senha não pode ser vazia ou menor que 5';
                }
                return null;
              },
            ),
            if (_authMode == AuthMode.Signup)
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                ),
                onPressed: _submit,
                child:
                    Text(_authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'))
          ]),
        ),
      ),
    );
  }
}
