import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/presenters/presenters.dart';

class PrintedProductsIcon extends StatefulWidget {
  const PrintedProductsIcon({
    super.key,
  });

  @override
  State<PrintedProductsIcon> createState() => _PrintedProductsIconState();
}

class _PrintedProductsIconState extends State<PrintedProductsIcon> {
  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter presenter = Provider.of(context);

    return GestureDetector(
      key: const Key("PrintedProductsIcon"),
      onTap: presenter.goToCartPage,
      child: FittedBox(
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.list_outlined,
                color: Colors.grey,
                size: 28,
              ),
              onPressed: presenter.goToCartPage,
            ),
            Positioned(
              top: 2,
              right: 2,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 9,
                child: FittedBox(
                  child: Text(
                    presenter.saleRequestTemp?.Products.length.toString() ??
                        "0",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
