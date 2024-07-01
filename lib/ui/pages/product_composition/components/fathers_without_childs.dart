import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/pages/pages.dart';

class FathersWithoutChilds extends StatefulWidget {
  final ProductCompositionViewModel father;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  const FathersWithoutChilds({
    required this.father,
    required this.productsCompositionsViewModel,
    super.key,
  });

  @override
  State<FathersWithoutChilds> createState() => _FathersWithoutChildsState();
}

class _FathersWithoutChildsState extends State<FathersWithoutChilds> {
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 1,
          itemBuilder: (context, childIndex) {
            if (widget.father.IsOptionalItem == "false") {
              //se o item for obrigatório e não for um combo, já seleciona ele automaticamente
              widget.father.indexOfSelectedChild = childIndex;
            }

            return Column(
              children: [
                RadioListTile<int>(
                  value: childIndex,
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
                    children: [
                      ImageWidget(
                        ean: null,
                        plu: widget.father.PluChild!,
                        showLargeImageInShowDialog: true,
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.father.ChildName != null)
                              Text(
                                widget.father.ChildName!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quantidade ${widget.father.Quantity.toString().toBrazilianNumber()}",
                                ),
                                Text(
                                  productCompositionPresenter
                                      .calculateTotalLiquid(
                                          product: widget.father)
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      CommentRichText(comment: widget.father.commentFather!)
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
