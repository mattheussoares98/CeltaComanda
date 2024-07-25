import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';

class Childs extends StatefulWidget {
  final int indexOfSelectedFather;
  final ProductsViewModel selectedProduct;

  const Childs({
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    super.key,
  });

  @override
  State<Childs> createState() => _ChildsState();
}

class _ChildsState extends State<Childs> {
  ProductCompositionViewModel get selectedFather {
    ProductCompositionViewModel selectedFather =
        widget.selectedProduct.childsComposition![0];

    if (widget.indexOfSelectedFather <
        widget.selectedProduct.childsComposition!.length) {
      selectedFather = widget
          .selectedProduct.childsComposition![widget.indexOfSelectedFather];
    }

    return selectedFather;
  }

  void _updateSelectedIndex({
    required ProductCompositionPresenter productCompositionPresenter,
    required int? value,
  }) {
    setState(() {
      productCompositionPresenter.updateSelectedIndexOfProduct(
        father: selectedFather,
        index: value,
      );

      productCompositionPresenter.updateTotalLiquidCombox(
        widget.selectedProduct.childsComposition!,
      );

      productCompositionPresenter
          .updateComboxIsValid(widget.selectedProduct.childsComposition!);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: selectedFather.childs?.isEmpty == true
          ? 1
          : selectedFather.childs!.length,
      itemBuilder: (context, childsIndex) {
        ProductCompositionViewModel child;
        bool hasChilds = selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = selectedFather.childs![childsIndex];
        } else {
          child = selectedFather;
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              productCompositionPresenter: productCompositionPresenter,
              value: childsIndex,
            );
          },
          child: Row(
            children: [
              const SizedBox(width: 5),
              Radio<int>(
                value: childsIndex,
                groupValue: selectedFather.indexOfSelectedChild,
                visualDensity: VisualDensity.compact,
                toggleable: selectedFather.IsOptionalItem == "true",
                onChanged: (int? value) {
                  _updateSelectedIndex(
                    productCompositionPresenter: productCompositionPresenter,
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
        );
      },
    );
  }
}
