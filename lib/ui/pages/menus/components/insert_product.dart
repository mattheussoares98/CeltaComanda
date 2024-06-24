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
  void addProductInCart({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required String? comment,
  }) async {
    try {
      cartPresenter.addProductInCart(
        product: CartProductEntity(
          Product: widget.selectedProduct!.toEntity(),
          Comments: comment,
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

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: true);

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
                  onPressed: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: CommentsPage(
                                selectedProductName:
                                    widget.selectedProduct!.Name,
                              ),
                            ),
                          );
                        });
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.add_comment_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 33,
                      ),
                      if (commentsPresenter.hasSelectedComments)
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            maxRadius: 7,
                            child: FittedBox(
                              child: Text(
                                "1",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
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
                    onPressed: () {
                      addProductInCart(
                        menuPresenter: menuPresenter,
                        homePresenter: homePresenter,
                        cartPresenter: cartPresenter,
                        comment: "só adicionar os comentários aqui e já era",
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Inserir")),
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
                ),
              ],
            ),
    );
  }
}
