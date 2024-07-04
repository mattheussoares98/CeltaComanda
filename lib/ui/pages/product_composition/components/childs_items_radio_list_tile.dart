import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/pages/pages.dart';

class ChildsItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel father;
  final bool isFixedItemInCombox;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  final int itensPerLine;
  const ChildsItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.productsCompositionsViewModel,
    required this.itensPerLine,
    super.key,
  });

  @override
  State<ChildsItemsRadioListTile> createState() =>
      _ChildsItemsRadioListTileState();
}

class _ChildsItemsRadioListTileState extends State<ChildsItemsRadioListTile> {
  void _updateSelectedIndex({
    required ProductCompositionPresenter productCompositionPresenter,
    required int? value,
  }) {
    setState(() {
      if (widget.father.indexOfSelectedChild == value) {
        widget.father.indexOfSelectedChild = null;
      } else {
        widget.father.indexOfSelectedChild = value;
      }
    });
    productCompositionPresenter.updateTotalLiquidCombox(
      widget.productsCompositionsViewModel,
    );
    productCompositionPresenter
        .updateComboxIsValid(widget.productsCompositionsViewModel);
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.isFixedItemInCombox
          ? 1
          : (widget.father.childs!.length / widget.itensPerLine).ceil(),
      itemBuilder: (context, childIndex) {
        ProductCompositionViewModel? child;

        if (widget.isFixedItemInCombox &&
            widget.father.IsOptionalItem == "false") {
          //se o item for obrigatório e não for um combo, já seleciona ele automaticamente
          widget.father.indexOfSelectedChild = childIndex;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
              for (int i = childIndex * widget.itensPerLine;
                  i < (childIndex + 1) * widget.itensPerLine;
                  i++)
                if (i < widget.father.childs!.length)
                  Builder(
                    builder: (context) {
                      child = widget.isFixedItemInCombox
                          ? widget.father
                          : widget.father.childs?[i];

                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            _updateSelectedIndex(
                              productCompositionPresenter:
                                  productCompositionPresenter,
                              value: i,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 2, right: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(255, 240, 240, 240),
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showLargeImage(
                                      context: context,
                                      ean: null,
                                      productComplement: null,
                                      plu: child!.PluChild!,
                                      menuPresenter: menuPresenter,
                                      productName: child!.ChildName!,
                                    );
                                  },
                                  child: ImageWidget(
                                    ean: null,
                                    plu: child!.PluChild!,
                                    showLargeImageInShowDialog: true,
                                    height: 140,
                                    width: 140,
                                    beginAnimation: 1,
                                    endAnimation: 0.7,
                                  ),
                                ),
                                if (child!.ChildName != null)
                                  Expanded(
                                    child: Text(
                                      child!.ChildName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                Radio<int>(
                                  value: i,
                                  groupValue:
                                      widget.father.indexOfSelectedChild,
                                  visualDensity: VisualDensity.compact,
                                  toggleable:
                                      widget.father.IsOptionalItem == "true",
                                  onChanged: (int? value) {
                                    _updateSelectedIndex(
                                      productCompositionPresenter:
                                          productCompositionPresenter,
                                      value: value,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}
