import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class NameAndComment extends StatelessWidget {
  final PrintedProductsViewModel product;
  final String? comments;
  const NameAndComment({
    required this.product,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    final canceledBy = configurationsPresenter.loadedUsers
        ?.where((e) => e.UserId == product.UserIdOfCancellation)
        .first.Name;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${product.Product?.Name} ${product.IsCancelled == "true" ? " (cancelado)" : ""}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StringSize.size,
                ),
              ),
            ),
            if (product.IsCancelled == "true" && canceledBy != null)
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info, color: Colors.black),
                tooltip: "${R.string.canceledBy}: $canceledBy",
              )
          ],
        ),
        if (comments != null) Comment(comment: "($comments)"),
      ],
    );
  }
}
