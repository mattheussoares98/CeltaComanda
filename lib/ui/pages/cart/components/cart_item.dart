import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../products/components/components.dart';

class CartItem extends StatelessWidget {
  final ProductsViewModel product;
  const CartItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ImageWidget(product: product),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              product.name,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  iconSize: 20,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {},
                                  color: const Color(0xFFFF5963),
                                ),
                                const Text("1"),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                  iconSize: 20,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {},
                                  color: const Color(0xFFFF5963),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
