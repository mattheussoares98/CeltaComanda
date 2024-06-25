// ignore_for_file: use_build_context_synchronously
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/components/components.dart';
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
    CartPresenter cartPresenter = Provider.of(context, listen: false);

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
                            ImageWidget(
                              ean: null,
                              plu: father!.PluChild!,
                              showLargeImageInShowDialog: true,
                            ),
                            const SizedBox(width: 10),
                            if (father!.ChildName != null)
                              Expanded(
                                child: Text(
                                  father!.ChildName!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
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
                            Text(
                              cartPresenter
                                  .calculateProductTotalLiquid(father!)
                                  .toString()
                                  .toBrazilianNumber()
                                  .addBrazilianCoin(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                              ),
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
                                father: father!,
                                callSetState: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        if (father!.commentFather != null)
                          CommentRichText(comment: father!.commentFather!),
                        ItemsRadioListTile(
                          productsCompositionsViewModel:
                              widget.productsCompositions,
                          isFixedItemInCombox: father!.childs?.isEmpty == true,
                          father: father!,
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
                      try {
                        productCompositionPresenter
                            .certifyComboxIsValid(widget.productsCompositions);

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
                            bool updatedCombox =
                                await cartPresenter.addConfirmedCombox(
                              selectedChilds: widget.productsCompositions,
                              totalPrice: snapshot.data!,
                              father: widget.product,
                              quantity: productCompositionPresenter
                                  .totalComboxQuantity,
                            );

                            if (updatedCombox) {
                              Navigator.of(context).pop();
                              showAlertMessage(
                                  context, "Combo adicionado com sucesso");
                            }
                          },
                        );
                      } catch (e) {
                        e;
                      }
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
                              return const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Salvar"),
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
