import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductItem extends StatelessWidget {
  final SaleRequestTempProductsViewModel product;
  final SaleRequestTempViewModel saleRequestTempViewModel;

  const ProductItem({
    required this.product,
    required this.saleRequestTempViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ImageWidget(product: product),
        Column(
          children: [
            ProductTempDetails(
              Product: product.Product,
              onPressedAddQuantity: () {},
              onPressedReduceQuantity: () {},
              onPressedRemoveProduct: null,
            ),
            Text("DeliveryControl: ${saleRequestTempViewModel.DeliveryControl}"),
            Text("Comments: ${saleRequestTempViewModel.Comments}"),
            Text("EnterpriseId: ${saleRequestTempViewModel.EnterpriseId}"),
            Text("PersonalizedCode: ${saleRequestTempViewModel.PersonalizedCode}"),
            Text("TotalLiquid: ${saleRequestTempViewModel.TotalLiquid}"),
          ],
        ),
      ],
    );
  }
}
