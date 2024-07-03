import 'dart:async';

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/mixins/mixins.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';

class InsertProductButton extends StatefulWidget {
  final ProductsViewModel? selectedProduct;
  final bool popScreen;
  const InsertProductButton({
    required this.selectedProduct,
    required this.popScreen,
    super.key,
  });

  @override
  State<InsertProductButton> createState() => _InsertProductButtonState();
}

class _InsertProductButtonState extends State<InsertProductButton>
    with LoadingManager, UIErrorManager {
  Future<void> addProductInCart({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required CommentsPresenter commentsPresenter,
  }) async {
    try {
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

      Future.delayed(Duration.zero, () {
        if (widget.popScreen && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
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
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: true);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return Padding(
      padding: const EdgeInsets.only(right: 3.0),
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
                        size: getIconSize(context),
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
                SizedBox(
                    width: MediaQuery.of(context).size.width > 400 ? 30 : 8),
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
                                    fontSize: hasMinWidth(context) ? 22 : 17,
                                  ),
                                ),
                              ),
                              Text(
                                (widget.selectedProduct!.SaleRetailPraticed
                                            .toDouble() *
                                        widget.selectedProduct!.productQuantity
                                            .toDouble())
                                    .toString()
                                    .toBrazilianNumber()
                                    .addBrazilianCoin(),
                                style: TextStyle(
                                  fontSize: hasMinWidth(context) ? 22 : 17,
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
    );
  }
}
