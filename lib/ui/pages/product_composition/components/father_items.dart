import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class FatherItems extends StatefulWidget {
  final List<ProductCompositionViewModel> productsCompositions;
  const FatherItems(this.productsCompositions, {super.key});

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

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(3, 12, 3, 0),
      child: Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.productsCompositions.length,
            itemBuilder: (context, index) {
              final father = widget.productsCompositions[index];

              if (father.childs?.isEmpty == true) {
                return Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ItemsRadioListTile(
                          isFixedItemInCombox: true,
                          father: father,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                        isFixedItemInCombox: father.childs?.isEmpty == true,
                        father: father,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
            onPressed: () {
              bool comboxIsValid = productCompositionPresenter.comboxIsValid();
              if (!comboxIsValid) {
                showErrorMessage(
                  context,
                  R.string.msgInvalidCombox,
                );
              }
            },
            child: const Text("Salvar combo"),
          ),
        ],
      ),
    );
  }
}
