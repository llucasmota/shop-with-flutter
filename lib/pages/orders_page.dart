import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus pedidos',
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (context, index) {
          return OrderWidget(order: orders.items[index]);
        },
      ),
    );
  }
}
