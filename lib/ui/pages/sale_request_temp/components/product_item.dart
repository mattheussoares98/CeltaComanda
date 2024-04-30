import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductItem extends StatelessWidget {
  final SaleRequestTempProductsViewModel product;

  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetails(
          isPrintedProducts: false,
          Product: product.Product,
          onPressedAddQuantity: () async {
            await saleRequestTempPresenter.addProductQuantity(
              url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
              saleRequestProductTempId:
                  int.parse(product.SaleRequestProductTempId),
            );
          },
          onPressedReduceQuantity: () async {
            await saleRequestTempPresenter.subtractProductQuantity(
              url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
              saleRequestProductTempId:
                  int.parse(product.SaleRequestProductTempId),
              productQuantity: int.parse(product.Quantity),
            );
          },
          onPressedRemoveProduct: null,
          quantity: product.Quantity,
          value: product.Value,
          totalLiquid: product.TotalLiquid,
          comments: product.Comments,
        ),
        // if (product.Comments != null) Text("Comments: ${product.Comments}"),
        // Text("SaleRequestProductTempId ${product.SaleRequestProductTempId}"),
        // Text("IsPrinted ${product.IsPrinted}"),

        // Text("SaleRequestTempId ${product.SaleRequestTempId}"),
        // Text("ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
        // Text("TotalLiquid ${product.TotalLiquid}"),
        // Text("Quantity ${product.Quantity}"),
        // Text("Value ${product.Value}"),
        // Text("PLU ${product.ProductPriceLookUpCode}"),
      ],
    );
  }
}
