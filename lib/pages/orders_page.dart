import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  Future<void> _refreshingOrders(BuildContext context) async {
    Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<OrderList>(context, listen: false).loadOrders().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

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
      body: RefreshIndicator(
        onRefresh: () => _refreshingOrders(context),
        child: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (context, index) {
            return OrderWidget(order: orders.items[index]);
          },
        ),
      ),
    );
  }
}
