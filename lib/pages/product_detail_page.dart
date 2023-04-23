import 'package:flutter/material.dart';

import 'package:shop/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            // fixo
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                  begin: Alignment(0, 0.8),
                  end: Alignment(0, 0),
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.6),
                    Color.fromRGBO(0, 0, 0, 0),
                  ],
                )))
              ]),
              centerTitle: true,
              title: Text(
                product.name,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              'R\$ ${product.price}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
            // colocado para teste apenas
            SizedBox(
              height: 1000,
            ),
            Text('Fim')
          ]))
        ],
      ),
    );
  }
}
