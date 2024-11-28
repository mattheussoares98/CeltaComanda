import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ReloadProductsIconButton extends StatelessWidget {
  final int? selectedOriginCommand;
  const ReloadProductsIconButton({
    required this.selectedOriginCommand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return IconButton(
      onPressed: selectedOriginCommand == null
          ? null
          : () async {
              await sendProductsToAnotherTablePresenter
                  .loadProducts(selectedOriginCommand!);
            },
      icon: const Icon(Icons.refresh),
    );
  }
}
