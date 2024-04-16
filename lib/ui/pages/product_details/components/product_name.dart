import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final String name;
  const ProductName({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Color(0xFF0F1113),
          fontSize: 18,
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
