import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions { Favoritos, Todos }

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductList>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_horiz_rounded,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favoritos,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.Todos,
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favoritos) {
                productList.showFavoriteOnly();
              } else {
                productList.showAll();
              }
            },
          ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}
