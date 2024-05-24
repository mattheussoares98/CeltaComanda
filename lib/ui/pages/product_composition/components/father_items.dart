import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FatherItems extends StatefulWidget {
  final List<ProductCompositionViewModel> productsCompositions;
  final ProductsViewModel product;
  const FatherItems({
    required this.productsCompositions,
    required this.product,
    super.key,
  });

  @override
  State<FatherItems> createState() => _FatherItemsState();
}

class _FatherItemsState extends State<FatherItems> {
  int selectedIndex = -1;
  final commentFocusNode = FocusNode();

  Future<void> changeFocusToCommentFocusNode() async {
    if (commentFocusNode.hasFocus &&
        MediaQuery.of(NavigatorKey.navigatorKey.currentState!.context)
                .viewInsets
                .bottom ==
            0) {
      await Future.delayed(Duration.zero);
      commentFocusNode.unfocus();
    }
    await Future.delayed(Duration.zero);
    commentFocusNode.requestFocus();
  }

  void updateShowCommentFormField(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = -1;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  ProductCompositionViewModel? father;

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(3, 12, 3, 0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.productsCompositions.length,
              itemBuilder: (context, index) {
                father = widget.productsCompositions[index];

                if (father!.childs?.isEmpty == true) {
                  return Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ItemsRadioListTile(
                            productsCompositionsViewModel:
                                widget.productsCompositions,
                            isFixedItemInCombox: true,
                            father: father!,
                            commentFocusNode: commentFocusNode,
                            changeFocusToCommentFocusNode:
                                changeFocusToCommentFocusNode,
                            updateShowCommentFormField: () {
                              updateShowCommentFormField(index);
                            },
                            updateSelectedIndex: () {
                              if (selectedIndex == index) {
                                setState(() {
                                  selectedIndex = -1;
                                });
                              } else {
                                setState(() {
                                  selectedIndex = index;
                                });
                              }
                            },
                            index: index,
                            selectedIndex: selectedIndex,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (father!.ChildName != null)
                              Text(
                                father!.ChildName!,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            if (father!.PluChild != null)
                              Text(
                                "PLU ${father!.PluChild!}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (father!.Quantity != null)
                              Text(
                                "Quantidade ${father!.Quantity!.toBrazilianNumber()}",
                              ),
                            Text(father!.OfferPrice != null &&
                                    father!.OfferPrice! == "0.0"
                                ? "Preço ${father!.SalePrice!.toBrazilianNumber()}"
                                    .addBrazilianCoin()
                                : "Preço ${father!.OfferPrice!.toBrazilianNumber()}"
                                    .addBrazilianCoin()),
                          ],
                        ),
                        if (father!.IncrementValue.toString().toDouble() > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "+",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    "Acréscimo: ${father!.IncrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (father!.IsOptionalItem != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                father!.IsOptionalItem == "true"
                                    ? "Item opcional"
                                    : "Item obrigatório",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green,
                                  fontSize: 17,
                                ),
                              ),
                              AddCommentButton(
                                updateShowCommentFormField: () {
                                  updateShowCommentFormField(index);
                                },
                                changeFocusToCommentFocusNode: () async {
                                  changeFocusToCommentFocusNode();
                                },
                              ),
                            ],
                          ),
                        ItemsRadioListTile(
                          productsCompositionsViewModel:
                              widget.productsCompositions,
                          isFixedItemInCombox: father!.childs?.isEmpty == true,
                          father: father!,
                          commentFocusNode: commentFocusNode,
                          changeFocusToCommentFocusNode:
                              changeFocusToCommentFocusNode,
                          updateShowCommentFormField: () {
                            updateShowCommentFormField(index);
                          },
                          updateSelectedIndex: () {
                            if (selectedIndex == index) {
                              setState(() {
                                selectedIndex = -1;
                              });
                            } else {
                              setState(() {
                                selectedIndex = index;
                              });
                            }
                          },
                          index: index,
                          selectedIndex: selectedIndex,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Builder(builder: (context) {
            return StreamBuilder<double>(
                stream: productCompositionPresenter.totalPriceComboxStream,
                builder: (context, snapshot) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      bool isValid =
                          productCompositionPresenter.comboxIsValid();
                      if (!isValid) {
                        return;
                      }
                      notificationDialog(
                        context: context,
                        titleMessage: "Salvar combo?",
                        cancelMessage: "Cancelar",
                        confirmMessage: "Confirmar",
                        content: ComboxSummaryNotification(
                          fatherName: widget.product.Name,
                          productsCompositions: widget.productsCompositions,
                          totalPrice: snapshot.data!,
                        ),
                        onPress: () async {
                          await productCompositionPresenter.updateSaleRequest(
                            homePresenter: homePresenter,
                            saleRequestTempPresenter: saleRequestTempPresenter,
                            productsCompositions: widget.productsCompositions,
                          );
                        },
                      );
                    },
                    child: Builder(builder: (context) {
                      Future.delayed(Duration.zero, () {
                        productCompositionPresenter.updateTotalLiquidCombox(
                            widget.productsCompositions);
                      });

                      return StreamBuilder<double>(
                          stream: productCompositionPresenter
                              .totalPriceComboxStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "TOTAL: ${snapshot.data != null ? snapshot.data.toString().toBrazilianNumber().addBrazilianCoin() : 0.toString().toBrazilianNumber().addBrazilianCoin()}",
                                  ),
                                  const Text("Salvar combo"),
                                ],
                              );
                            }
                            return const SizedBox(height: 0);
                          });
                    }),
                  );
                });
          }),
        ],
      ),
    );
  }
}
