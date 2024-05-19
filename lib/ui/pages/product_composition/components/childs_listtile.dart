import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class ChildsListTile extends StatefulWidget {
  final ProductCompositionViewModel productComposition;
  const ChildsListTile(
    this.productComposition, {
    super.key,
  });

  @override
  State<ChildsListTile> createState() => _ChildsListTileState();
}

class _ChildsListTileState extends State<ChildsListTile> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.productComposition.childs?.length,
      itemBuilder: (context, childIndex) {
        final child = widget.productComposition.childs?[childIndex];
        return RadioListTile<int>(
          value: childIndex,
          groupValue: widget.productComposition.indexOfSelectedChild,
          dense: true,
          controlAffinity: ListTileControlAffinity.trailing,
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
                  ? "Preço ${child?.SalePrice!.toBrazilianNumber()}".toBrazilianPrice()
                  : "Preço ${child?.OfferPrice!.toBrazilianNumber()}".toBrazilianPrice()),
            ],
          ),
        );
      },
    );
  }
}
