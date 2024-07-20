import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/mixins/mixins.dart';
import '../../../../ui/pages/pages.dart';
import '../../../components/components.dart';

class InsertProductButton extends StatefulWidget {
  final ProductsViewModel? selectedProduct;
  const InsertProductButton({
    required this.selectedProduct,
    super.key,
  });

  @override
  State<InsertProductButton> createState() => _InsertProductButtonState();
}

class _InsertProductButtonState extends State<InsertProductButton>
    with LoadingManager, UIErrorManager {
  Future<void> _showModalToSelectComments({
    required CartPresenter cartPresenter,
    required CommentsPresenter commentsPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    await showModalBottomSheet(
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
                doOnClickInConfirmButton: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  await cartPresenter.addProductInCart(
                    commentsPresenter: commentsPresenter,
                    product: CartProductEntity(
                      Product: widget.selectedProduct!.toEntity(),
                      Comments:
                          "no cartPresenter.addProductInCart atualiza os comentários adicionando o que foi selecionado pelo usuário",
                      TotalLiquid: widget.selectedProduct!.productQuantity *
                          widget.selectedProduct!.SaleRetailPraticed.toDouble(),
                      Quantity: widget.selectedProduct!.productQuantity,
                      Value:
                          widget.selectedProduct!.SaleRetailPraticed.toDouble(),
                      ProductPriceLookUpCode:
                          widget.selectedProduct!.PriceLookupCode,
                    ),
                    menuPresenter: menuPresenter,
                  );
                },
                selectedProductName: widget.selectedProduct!.Name,
                internalCodeOnErp:
                    widget.selectedProduct!.InternalCodeOnERP!.toInt(),
              ),
            ),
          );
        });
    commentsPresenter.unselectAllComments();
  }

  Future<void> addProductInCart({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required CommentsPresenter commentsPresenter,
  }) async {
    setState(() {});

    final comments = commentsPresenter.loadedComments.where((e) =>
        int.parse(e.ProductInternalCodeOnErp) ==
        widget.selectedProduct!.InternalCodeOnERP!.toInt());

    try {
      if (comments.isNotEmpty) {
        await _showModalToSelectComments(
          cartPresenter: cartPresenter,
          commentsPresenter: commentsPresenter,
          menuPresenter: menuPresenter,
        );
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        await cartPresenter.addProductInCart(
          commentsPresenter: commentsPresenter,
          product: CartProductEntity(
            Product: widget.selectedProduct!.toEntity(),
            Comments:
                "no cartPresenter.addProductInCart atualiza os comentários adicionando o que foi selecionado pelo usuário",
            TotalLiquid: widget.selectedProduct!.productQuantity *
                widget.selectedProduct!.SaleRetailPraticed.toDouble(),
            Quantity: widget.selectedProduct!.productQuantity,
            Value: widget.selectedProduct!.SaleRetailPraticed.toDouble(),
            ProductPriceLookUpCode: widget.selectedProduct!.PriceLookupCode,
          ),
          menuPresenter: menuPresenter,
        );
      }
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

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: true);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: true);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: widget.selectedProduct?.productQuantity == null
            ? TextButton(
                onPressed: null,
                child: Text("Selecione um produto",
                    style: TextStyle(
                      fontSize: hasMinWidth(context) ? 23 : 15,
                    )),
              )
            : Row(
                children: [
                  SizedBox(width: hasMinWidth(context) ? 30 : 8),
                  UpdateQuantity(
                    iconSize: hasMinWidth(context) ? 50 : 20,
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
                  SizedBox(width: hasMinWidth(context) ? 30 : 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () async {
                        await addProductInCart(
                          menuPresenter: menuPresenter,
                          homePresenter: homePresenter,
                          cartPresenter: cartPresenter,
                          commentsPresenter: commentsPresenter,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (hasMinWidth(context))
                                  Icon(
                                    Icons.shopping_cart,
                                    size: getIconSize(context),
                                  ),
                                SizedBox(
                                  width: hasMinWidth(context) ? 30 : 8,
                                ),
                                Expanded(
                                  child: Text(
                                    hasMinWidth(context)
                                        ? "Inserir no carrinho"
                                        : "Inserir",
                                    style: TextStyle(
                                      fontSize: getStringSize(context),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    (widget.selectedProduct!.SaleRetailPraticed
                                                .toDouble() *
                                            widget.selectedProduct!
                                                .productQuantity
                                                .toDouble())
                                        .toString()
                                        .toBrazilianNumber()
                                        .addBrazilianCoin(),
                                    style: TextStyle(
                                      fontSize: getStringSize(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
