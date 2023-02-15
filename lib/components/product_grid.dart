import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductGrid extends StatelessWidget {
  final bool mustBeShowFavoriteOnly;
  const ProductGrid({
    required this.mustBeShowFavoriteOnly,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context, listen: true);
    final List<Product> loadProducts =
        mustBeShowFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // SliverGridDelegateWithFixedCrossAxisCount no eixo cruzado, ou seja horizontal
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 itens por linha
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, // espaço lateral
        mainAxisSpacing: 10, //espaço superior e inferior
      ),
      itemCount: loadProducts.length,
      itemBuilder: (context, index) {
        /**
         * funciona de forma similar a um componten de Provider que envolve 
         * uma área
         */
        return ChangeNotifierProvider.value(
          value: loadProducts[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
