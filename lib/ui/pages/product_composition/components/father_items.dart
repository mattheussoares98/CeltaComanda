import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FatherItems extends StatelessWidget {
  final List<ProductCompositionViewModel> productsCompositions;
  const FatherItems(this.productsCompositions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: productsCompositions.length,
        itemBuilder: (context, fatherIndex) {
          final father = productsCompositions[fatherIndex];

          if (father.childs?.isEmpty == true) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ItemsRadioListTile(
                      isFixedItemInCombox: true,
                      productComposition: father,
                    ),
                  ],
                ),
              ),
            );
          }

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (father.ChildName != null)
                        Text(
                          father.ChildName!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      if (father.PluChild != null)
                        Text(
                          "PLU ${father.PluChild!}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (father.Quantity != null)
                        Text(
                          "Quantidade ${father.Quantity!.toBrazilianNumber()}",
                        ),
                      Text(father.OfferPrice != null &&
                              father.OfferPrice! == "0.0"
                          ? "Preço ${father.SalePrice!.toBrazilianNumber()}"
                              .addBrazilianCoin()
                          : "Preço ${father.OfferPrice!.toBrazilianNumber()}"
                              .addBrazilianCoin()),
                    ],
                  ),
                  if (father.IsOptionalItem != null)
                    Text(
                      father.IsOptionalItem == "true"
                          ? "Item opcional"
                          : "Item obrigatório",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                        fontSize: 17,
                      ),
                    ),
                  ItemsRadioListTile(
                    isFixedItemInCombox: father.childs?.isEmpty == true,
                    productComposition: father,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
