import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/pages/pages.dart';

class ItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel father;
  final bool isFixedItemInCombox;
  final Function() updateSelectedIndex;
  final int index;
  final int selectedIndex;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  const ItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.productsCompositionsViewModel,
    super.key,
  });

  @override
  State<ItemsRadioListTile> createState() => _ItemsRadioListTileState();
}

class _ItemsRadioListTileState extends State<ItemsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount:
              widget.isFixedItemInCombox ? 1 : widget.father.childs?.length,
          itemBuilder: (context, childIndex) {
            final child = widget.isFixedItemInCombox
                ? widget.father
                : widget.father.childs?[childIndex];

            if (widget.isFixedItemInCombox &&
                widget.father.IsOptionalItem == "false") {
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
                      ImageWidget(
                        ean: null,
                        plu: child!.PluChild!,
                        showLargeImageInShowDialog: true,
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (child.ChildName != null)
                              Text(
                                child.ChildName!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (widget.isFixedItemInCombox)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quantidade ${child.Quantity.toString().toBrazilianNumber()}",
                                  ),
                                  Text(
                                    productCompositionPresenter
                                        .calculateTotalLiquid(product: child)
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isFixedItemInCombox)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            child.IsOptionalItem == "true"
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
                            father: child,
                            callSetState: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
