import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ProductDetailsCartIcon extends StatelessWidget {
  final void Function()? goToCartPage;
  const ProductDetailsCartIcon({
    required this.goToCartPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.85, -0.4),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: CartIcon(
            goToCartPage: goToCartPage,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
