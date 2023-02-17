import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemComponent extends StatelessWidget {
  final CartItem cartItem;

  const CartItemComponent({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(
                        child: Text(
                      '${cartItem.price}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6?.color),
                    )),
                  ),
                )),
            title: Text(cartItem.name),
            subtitle: Text('Total: R\$ ${cartItem.price * cartItem.quantity}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
      // onDismissed: (_) {
      //   Provider.of<Cart>(
      //     context,
      //     listen: false,
      //   ).removeItem(cartItem.productId);
      // },
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Tem certeza?',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            content: const Text('Quer remover o item?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('Não')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('Sim'))
            ],
          ),
        );
      },
    );
  }
}
