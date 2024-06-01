import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';

class InsertProduct extends StatefulWidget {
  final ProductsViewModel? selectedProduct;
  const InsertProduct({
    required this.selectedProduct,
    super.key,
  });

  @override
  State<InsertProduct> createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {
  @override
  Widget build(BuildContext context) {
    Future<void> addProductInCart({
      required MenuPresenter menuPresenter,
      required HomePresenter homePresenter,
      required SaleRequestTempPresenter saleRequestTempPresenter,
    }) async {
      try {
        saleRequestTempPresenter.addProductInCart(
          product: CartProductEntity(
            Product: widget.selectedProduct!.toEntity(),
            Comments: "implementar a parte de comentário quando está adicionando o produto pelo menu",
            TotalLiquid: widget.selectedProduct!.productQuantity *
                widget.selectedProduct!.SaleRetailPraticed.toDouble(),
            Quantity: widget.selectedProduct!.productQuantity,
            Value: widget.selectedProduct!.SaleRetailPraticed.toDouble(),
            ProductPriceLookUpCode: widget.selectedProduct!.PriceLookupCode,
          ),
          menuPresenter: menuPresenter,
        );
        setState(() {});
      } catch (e) {
        e;
      }
    }

    void addProductQuantity(MenuPresenter menuPresenter) {
      setState(() {
        widget.selectedProduct?.productQuantity++;
      });
    }

    void subtractProductQuantity(MenuPresenter menuPresenter) {
      setState(() {
        widget.selectedProduct?.productQuantity--;
      });
    }

    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: widget.selectedProduct?.productQuantity == null
          ? const TextButton(
              onPressed: null,
              child: Text("Selecione um produto"),
            )
          : Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                UpdateQuantity(
                  showDeleteIcon: false,
                  productQuantity: widget.selectedProduct!.productQuantity,
                  onPressedReduceQuantity: widget.selectedProduct != null &&
                          widget.selectedProduct!.productQuantity <= 1
                      ? null
                      : () {
                          subtractProductQuantity(menuPresenter);
                        },
                  onPressedAddQuantity: () {
                    addProductQuantity(menuPresenter);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      await addProductInCart(
                        menuPresenter: menuPresenter,
                        homePresenter: homePresenter,
                        saleRequestTempPresenter: saleRequestTempPresenter,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Inserir"),
                        Text((widget.selectedProduct!.SaleRetailPraticed
                                    .toDouble() *
                                widget.selectedProduct!.productQuantity
                                    .toDouble())
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
