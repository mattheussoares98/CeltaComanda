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
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FittedBox(
                child: Text(
                  "Comentários do produto",
                  style: TextStyle(
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
