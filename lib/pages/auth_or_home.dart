import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro'),
            );
          } else {
            return auth.isAuthenticated
                ? const ProductsOverviewPage()
                : const AuthPage();
          }
        });
  }
}
