import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/pages/pages.dart';

class FathersWithoutChilds extends StatefulWidget {
  final ProductCompositionViewModel father;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  const FathersWithoutChilds({
    required this.father,
    required this.productsCompositionsViewModel,
    super.key,
  });

  @override
  State<FathersWithoutChilds> createState() => _FathersWithoutChildsState();
}

class _FathersWithoutChildsState extends State<FathersWithoutChilds> {
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
            BoxShadow(
              offset: Offset(-2, -2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 1,
            itemBuilder: (context, childIndex) {
              if (widget.father.IsOptionalItem == "false") {
                //se o item for obrigatório e não for um combo, já seleciona ele automaticamente
                widget.father.indexOfSelectedChild = childIndex;
              }

              return Column(
                children: [
                  RadioListTile<int>(
                    value: childIndex,
                    groupValue: widget.father.indexOfSelectedChild,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.trailing,
                    toggleable: widget.father.IsOptionalItem == "true",
                    onChanged: (int? value) {
                      setState(() {
                        widget.father.indexOfSelectedChild = value;
                      });
                      productCompositionPresenter.updateTotalLiquidCombox(
                          widget.productsCompositionsViewModel);
                    },
                    subtitle: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showLargeImage(
                              context: context,
                              ean: null,
                              plu: widget.father.PluChild!,
                              productComplement: null,
                              showInsertButton: true,
                              selectedProduct: null,
                              menuPresenter: menuPresenter,
                              productName: widget.father.ChildName,
                            );
                          },
                          child: ImageWidget(
                            ean: null,
                            plu: widget.father.PluChild!,
                            productComplement: null,
                            showLargeImageInShowDialog: true,
                            height: 140,
                            width: 140,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FatherNameText(name: widget.father.ChildName!),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  QuantityText(
                                    quantity: widget.father.Quantity!,
                                  ),
                                  PriceText(
                                    quantity: productCompositionPresenter
                                        .calculateTotalLiquid(
                                            product: widget.father),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final dynamic tooltip = _tooltipKey.currentState;
                              tooltip.ensureTooltipVisible();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Tooltip(
                                    key: _tooltipKey,
                                    message: 'Esse produto é obrigatório',
                                    child: Icon(
                                      Icons.info,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Item obrigatório",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: hasMinWidth(context) ? 23 : 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AddCommentButton(
                            father: widget.father,
                            callSetState: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      if (widget.father.commentFather != null)
                        CommentRichText(comment: widget.father.commentFather!)
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
