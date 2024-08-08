import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TitlePage extends StatelessWidget {
  final String selectedProductName;
  const TitlePage({
    required this.selectedProductName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  R.string.commentsOfProduct,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              FittedBox(
                  child: Text(
                selectedProductName,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: hasMinWidth(context) ? 30 : 20,
                  fontStyle: FontStyle.italic,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
