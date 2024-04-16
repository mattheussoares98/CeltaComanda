import 'package:flutter/material.dart';

class ProductSubtitle extends StatelessWidget {
  final String title;
  const ProductSubtitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Color(0xFF57636C),
          fontSize: 14,
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
