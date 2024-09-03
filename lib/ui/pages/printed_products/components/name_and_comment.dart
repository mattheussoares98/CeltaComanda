import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class NameAndComment extends StatelessWidget {
  final ProductsViewModel product;
  final String? comments;
  const NameAndComment({
    required this.product,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          product.Name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getStringSize(context),
          ),
        ),
        if (comments != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Comment(comment: "($comments)"),
          ),
      ],
    );
  }
}
