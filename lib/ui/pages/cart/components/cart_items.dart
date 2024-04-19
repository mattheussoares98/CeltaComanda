import 'package:flutter/material.dart';

import '../../pages.dart';

class CartItems extends StatelessWidget {
  final List<ProductsViewModel> productViewModel;
  const CartItems({
    required this.productViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(
              0,
              2,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productViewModel.length,
              itemBuilder: (context, index) {
                final cartItem = productViewModel[index];
        
                return CartItem(product: cartItem);
              },
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                  ),
                  const Divider(
                    height: 32,
                    thickness: 2,
                    color: Color(0xFFE0E3E7),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 0, 0, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Base Price',
                            ),
                            Text(
                              '\$156.00',
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 8, 0, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text(
                                    'Total',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.info_outlined,
                                      color: Color(0xFF57636C),
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const Text(
                                '\$230.20',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
