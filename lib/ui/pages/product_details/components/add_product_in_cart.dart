import 'package:flutter/material.dart';

class AddProductInCart extends StatelessWidget {
  final void Function()? onPressed;
  final String price;
  const AddProductInCart({
    required this.onPressed,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '1 Item • R\$ $price',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            // color: Color(0x99FFFFFF),
            fontSize: 14,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Adicionar"),
        )
      ],
    );
  }
}
