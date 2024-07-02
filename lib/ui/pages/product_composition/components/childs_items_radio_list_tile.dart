import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/pages/pages.dart';

class ChildsItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel father;
  final bool isFixedItemInCombox;
  final Function() updateSelectedIndex;
  final int index;
  final int selectedIndex;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  final int itensPerLine;
  const ChildsItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.productsCompositionsViewModel,
    required this.itensPerLine,
    super.key,
  });

  @override
  State<ChildsItemsRadioListTile> createState() => _ChildsItemsRadioListTileState();
}

class _ChildsItemsRadioListTileState extends State<ChildsItemsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

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
                  Builder(builder: (context) {
                    child = widget.isFixedItemInCombox
                        ? widget.father
                        : widget.father.childs?[i];
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        child: RadioListTile<int>(
                          contentPadding: const EdgeInsets.all(0),
                          value: i,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: ImageWidget(
                                  ean: null,
                                  plu: child!.PluChild!,
                                  productComplement: null,
                                  showLargeImageInShowDialog: true,
                                  height: 140,
                                  width: 80,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (child!.ChildName != null)
                                      Text(
                                        child!.ChildName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    if (widget.isFixedItemInCombox)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Quantidade ${child!.Quantity.toString().toBrazilianNumber()}",
                                          ),
                                          Text(
                                            productCompositionPresenter
                                                .calculateTotalLiquid(
                                                    product: child!)
                                                .toString()
                                                .toBrazilianNumber()
                                                .addBrazilianCoin(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}
