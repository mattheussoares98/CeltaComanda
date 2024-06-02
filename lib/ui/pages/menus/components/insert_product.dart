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
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required String? comment,
  }) async {
    try {
      saleRequestTempPresenter.addProductInCart(
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
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: widget.selectedProduct?.productQuantity == null
          ? const TextButton(
              onPressed: null,
              child: Text("Selecione um produto"),
            )
          : StreamBuilder<String?>(
              stream: menuPresenter.productCommentStream,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        final commentsController = TextEditingController();

                        if (snapshot.hasData) {
                          commentsController.text = snapshot.data!;
                        } else {
                          //quando o usuário digita mas não confirma o comentário, ainda alterou o controller. Por isso precisa limpar se não houver dados no comentário da stream
                          commentsController.clear();
                        }

                        notificationDialog(
                          context: context,
                          titleMessage: snapshot.hasData
                              ? "Alterar comentário"
                              : "Inserir comentário",
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 100,
                                  ),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: commentsController,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(3, 10, 3, 3),
                                      label: Text("Inserir comentário"),
                                      hintText: "Comentário",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPress: () async {
                            if (commentsController.text.isNotEmpty) {
                              menuPresenter.updateProductComment(
                                commentsController.text,
                              );
                            }
                          },
                        );
                      },
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.add_comment_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 33,
                          ),
                          if (snapshot.hasData)
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
                            saleRequestTempPresenter: saleRequestTempPresenter,
                            comment: snapshot.data,
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
                );
              }),
    );
  }
}
