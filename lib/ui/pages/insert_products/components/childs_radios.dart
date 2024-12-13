import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class ChildsRadios extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel selectedFather;
  final Function() callSetState;

  ChildsRadios({
    required this.selectedProduct,
    required this.selectedFather,
    required this.callSetState,
    super.key,
  });

  final Map<int, bool> _alreadyUpdated = {};

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: selectedFather.childs == null ||
              selectedFather.childs?.isEmpty == true
          ? 1
          : selectedFather.childs!.length,
      itemBuilder: (context, i) {
        _alreadyUpdated.putIfAbsent(i, () => false);

        ProductCompositionViewModel child;
        bool hasChilds = selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = selectedFather.childs![i];
        } else {
          child = selectedFather;
          Future.delayed(Duration.zero, () {
            if (child.IsOptionalItem == "false" &&
                _alreadyUpdated[i] == false) {
              _alreadyUpdated[i] = true;
              _updateSelectedIndex(
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                insertProductsPresenter: insertProductsPresenter,
                value: i,
                selectedFather: selectedFather,
                selectedProduct: selectedProduct,
              );
            }
          });
        }

        double? incrementValue;

        if (selectedFather.IncrementValue!.toDouble() > 0) {
          incrementValue = selectedFather.IncrementValue!.toDouble();
        } else if (child.IncrementValue!.toDouble() > 0) {
          incrementValue = child.IncrementValue!.toDouble();
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              insertProductsPresenter: insertProductsPresenter,
              value: i,
              selectedFather: selectedFather,
              selectedProduct: selectedProduct,
            );
            callSetState();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Radio<int>(
                value: i,
                groupValue: selectedFather.indexOfSelectedChild,
                visualDensity: VisualDensity.compact,
                toggleable: selectedFather.IsOptionalItem == "true",
                onChanged: (int? value) {
                  _updateSelectedIndex(
                    expansibleGroupFromProductPresenter:
                        expansibleGroupFromProductPresenter,
                    insertProductsPresenter: insertProductsPresenter,
                    value: value,
                    selectedFather: selectedFather,
                    selectedProduct: selectedProduct,
                  );
                  callSetState();
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
                      fontSize: StringSize.size,
                    ),
                  ),
                ),
              if (incrementValue != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "+ ${incrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: StringSize.size,
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
