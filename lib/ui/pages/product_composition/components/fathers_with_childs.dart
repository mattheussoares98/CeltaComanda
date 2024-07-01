import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class FathersWithChilds extends StatefulWidget {
  final ProductCompositionViewModel father;
  final List<ProductCompositionViewModel> productsCompositions;
  final int index;
  const FathersWithChilds({
    required this.father,
    required this.productsCompositions,
    required this.index,
    super.key,
  });

  @override
  State<FathersWithChilds> createState() => _FathersWithChildsState();
}

class _FathersWithChildsState extends State<FathersWithChilds> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageWidget(
                  ean: null,
                  plu: widget.father.PluChild!,
                  showLargeImageInShowDialog: true,
                  height: 150,
                  width: 150,
                ),
                const SizedBox(width: 10),
                if (widget.father.ChildName != null)
                  Expanded(
                    child: Text(
                      widget.father.ChildName!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.father.Quantity != null)
                  Text(
                    "Quantidade ${widget.father.Quantity!.toBrazilianNumber()}",
                  ),
                Text(
                  cartPresenter
                      .calculateProductTotalLiquid(widget.father)
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            if (widget.father.IsOptionalItem != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.father.IsOptionalItem == "true"
                        ? "Item opcional"
                        : "Item obrigatório",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
                      fontSize: 17,
                    ),
                  ),
                  AddCommentButton(
                    father: widget.father,
                    callSetState: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            if (widget.father.commentFather != null)
              CommentRichText(comment: widget.father.commentFather!),
            ItemsRadioListTile(
              productsCompositionsViewModel: widget.productsCompositions,
              isFixedItemInCombox: widget.father.childs?.isEmpty == true,
              father: widget.father,
              updateSelectedIndex: () {
                if (selectedIndex == widget.index) {
                  setState(() {
                    selectedIndex = -1;
                  });
                } else {
                  setState(() {
                    selectedIndex = widget.index;
                  });
                }
              },
              index: widget.index,
              selectedIndex: selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
