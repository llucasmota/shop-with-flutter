import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
            ),
            IconButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(
                          'Exclusão',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        content: const Text('Deseja realmente excluir?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Não')),
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Sim'))
                        ],
                      );
                    },
                  ).then((value) {
                    if (value ?? false) {
                      Provider.of<ProductList>(context, listen: false)
                          .removeProductByProductId(product.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Produto excluído com sucesso.',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  });

                  // Provider.of<ProductList>(context, listen: false)
                  //     .removeProductByProductId(product.id);

                  // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //   content: Text('Produto excluído com sucesso'),
                  //   duration: Duration(seconds: 2),
                  // ));
                  // Navigator.of(context).pushNamed(AppRoutes.HOME);
                },
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error)),
          ],
        ),
      ),
    );
  }
}
