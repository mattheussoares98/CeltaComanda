import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class ChildsRadios extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel selectedFather;
  final Function() callSetState;

  const ChildsRadios({
    required this.selectedProduct,
    required this.selectedFather,
    required this.callSetState,
    super.key,
  });

  @override
  State<ChildsRadios> createState() => _ChildsRadiosState();
}

class _ChildsRadiosState extends State<ChildsRadios> {
  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.selectedFather.childs?.isEmpty == true
          ? 1
          : widget.selectedFather.childs!.length,
      itemBuilder: (context, i) {
        ProductCompositionViewModel child;
        bool hasChilds = widget.selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = widget.selectedFather.childs![i];
        } else {
          child = widget.selectedFather;
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              insertProductsPresenter: insertProductsPresenter,
              value: i,
              selectedFather: widget.selectedFather,
              selectedProduct: widget.selectedProduct,
            );
            widget.callSetState();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Radio<int>(
                value: i,
                groupValue: widget.selectedFather.indexOfSelectedChild,
                visualDensity: VisualDensity.compact,
                toggleable: widget.selectedFather.IsOptionalItem == "true",
                onChanged: (int? value) {
                  _updateSelectedIndex(
                    expansibleGroupFromProductPresenter:
                        expansibleGroupFromProductPresenter,
                    insertProductsPresenter: insertProductsPresenter,
                    value: value,
                    selectedFather: widget.selectedFather,
                    selectedProduct: widget.selectedProduct,
                  );
                  widget.callSetState();
                },
              ),
              if (child.ChildName != null)
                Expanded(
                  child: Text(
                    child.ChildName!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: getStringSize(context),
                    ),
                  ),
                ),
              if (child.IncrementValue!.toDouble() > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "+ ${child.IncrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: getStringSize(context),
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

void _updateSelectedIndex({
  required InsertProductPresenter insertProductsPresenter,
  required int? value,
  required ProductCompositionViewModel selectedFather,
  required ProductsViewModel selectedProduct,
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
}) {
  insertProductsPresenter.updateSelectedIndexOfProduct(
    father: selectedFather,
    index: value,
    expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
  );

  insertProductsPresenter.updateTotalLiquid(
    selectedProduct,
  );
}
