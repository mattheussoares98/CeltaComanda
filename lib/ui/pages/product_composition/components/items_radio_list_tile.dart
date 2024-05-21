import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/pages/pages.dart';

class ItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel productComposition;
  final bool isFixedItemInCombox;
  const ItemsRadioListTile({
    required this.productComposition,
    required this.isFixedItemInCombox,
    super.key,
  });

  @override
  State<ItemsRadioListTile> createState() => _ItemsRadioListTileState();
}

class _ItemsRadioListTileState extends State<ItemsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.isFixedItemInCombox
          ? 1
          : widget.productComposition.childs?.length,
      itemBuilder: (context, childIndex) {
        final child = widget.isFixedItemInCombox
            ? widget.productComposition
            : widget.productComposition.childs?[childIndex];
        return RadioListTile<int>(
          value: childIndex,
          groupValue: widget.isFixedItemInCombox &&
                  widget.productComposition.IsOptionalItem == "false"
              //se o item for obrigatório, já seleciona ele automaticamente e não deixa retirar a seleção
              ? 0
              : widget.productComposition.indexOfSelectedChild,
          dense: true,
          controlAffinity: ListTileControlAffinity.trailing,
          toggleable: widget.productComposition.IsOptionalItem == "true",
          onChanged: (int? value) {
            setState(() {
              widget.productComposition.indexOfSelectedChild = value;
            });
          },
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (child?.ChildName != null)
                Text(
                  child!.ChildName!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              if (child?.PluChild != null) Text("PLU ${child!.PluChild!}"),
              if (child?.Quantity != null)
                Text("Quantidade ${child!.Quantity!.toBrazilianNumber()}"),
              Text(child?.OfferPrice != null && child?.OfferPrice! == "0.0"
                  ? "Preço ${child?.SalePrice!.toBrazilianNumber()}"
                      .addBrazilianCoin()
                  : "Preço ${child?.OfferPrice!.toBrazilianNumber()}"
                      .addBrazilianCoin()),
              if (widget.isFixedItemInCombox)
                Text(
                  child?.IsOptionalItem == "true"
                      ? "Item opcional"
                      : "Item obrigatório",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.green,
                    fontSize: 17,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
