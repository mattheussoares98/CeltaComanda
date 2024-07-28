import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ChildsRadios extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final InsertProductsViewModel selectedFather;
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
  void _updateSelectedIndex({
    required InsertProductPresenter insertProductsPresenter,
    required int? value,
  }) {
    setState(() {
      insertProductsPresenter.updateSelectedIndexOfProduct(
        father: widget.selectedFather,
        index: value,
      );

      insertProductsPresenter.updateTotalLiquid(
        widget.selectedProduct,
      );

      insertProductsPresenter
          .updateChildsCompositionIsValid(widget.selectedProduct.childsComposition!);
    });
    widget.callSetState();
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.selectedFather.childs?.isEmpty == true
          ? 1
          : widget.selectedFather.childs!.length,
      itemBuilder: (context, childsIndex) {
        InsertProductsViewModel child;
        bool hasChilds = widget.selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = widget.selectedFather.childs![childsIndex];
        } else {
          child = widget.selectedFather;
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              insertProductsPresenter: insertProductsPresenter,
              value: childsIndex,
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Radio<int>(
                    value: childsIndex,
                    groupValue: widget.selectedFather.indexOfSelectedChild,
                    visualDensity: VisualDensity.compact,
                    toggleable: widget.selectedFather.IsOptionalItem == "true",
                    onChanged: (int? value) {
                      _updateSelectedIndex(
                        insertProductsPresenter:
                            insertProductsPresenter,
                        value: childsIndex,
                      );
                    },
                  ),
                  if (child.ChildName != null)
                    Text(
                      child.ChildName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
