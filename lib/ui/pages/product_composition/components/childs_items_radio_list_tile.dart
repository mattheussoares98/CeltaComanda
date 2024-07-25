import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';

class ChildsItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel father;
  final bool isFixedItemInCombox;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  const ChildsItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.productsCompositionsViewModel,
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
      productCompositionPresenter.updateSelectedIndexOfProduct(
        father: widget.father,
        index: value,
      );

      productCompositionPresenter.updateTotalLiquidCombox(
        widget.productsCompositionsViewModel,
      );

      productCompositionPresenter
          .updateComboxIsValid(widget.productsCompositionsViewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.isFixedItemInCombox ? 1 : widget.father.childs!.length,
      itemBuilder: (context, index) {
        if (widget.isFixedItemInCombox &&
            widget.father.IsOptionalItem == "false") {
          //se o item for obrigatório e não for um combo, já seleciona ele automaticamente
          widget.father.indexOfSelectedChild = index;
        }

        return ChildItemRadioListTile(
          updateSelectedIndex: () {
            _updateSelectedIndex(
              productCompositionPresenter: productCompositionPresenter,
              value: index,
            );
          },
          index: index,
          father: widget.father,
          child: widget.isFixedItemInCombox
              ? widget.father
              : widget.father.childs?[index],
        );
      },
    );
  }
}
