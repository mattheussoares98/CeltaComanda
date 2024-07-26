import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';

class Childs extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel selectedFather;

  const Childs({
    required this.selectedProduct,
    required this.selectedFather,
    super.key,
  });

  @override
  State<Childs> createState() => _ChildsState();
}

class _ChildsState extends State<Childs> {
  void _updateSelectedIndex({
    required ProductCompositionPresenter productCompositionPresenter,
    required int? value,
  }) {
    setState(() {
      productCompositionPresenter.updateSelectedIndexOfProduct(
        father: widget.selectedFather,
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
      itemCount: widget.selectedFather.childs?.isEmpty == true
          ? 1
          : widget.selectedFather.childs!.length,
      itemBuilder: (context, childsIndex) {
        ProductCompositionViewModel child;
        bool hasChilds = widget.selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = widget.selectedFather.childs![childsIndex];
        } else {
          child = widget.selectedFather;
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              productCompositionPresenter: productCompositionPresenter,
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
                        productCompositionPresenter:
                            productCompositionPresenter,
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
