import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
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
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
            BoxShadow(
              offset: Offset(-2, -2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
          ],
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 1,
          itemBuilder: (context, childIndex) {
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
                      widget.productsCompositionsViewModel,
                    );
                    productCompositionPresenter.updateComboxIsValid(
                      widget.productsCompositionsViewModel,
                    );
                  },
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showLargeImage(
                              context: context,
                              ean: null,
                              plu: widget.father.PluChild!,
                              productComplement: null,
                              showInsertButton: true,
                              selectedProduct: null,
                              menuPresenter: menuPresenter,
                              productName: widget.father.ChildName,
                            );
                          },
                          child: ImageWidget(
                            ean: null,
                            plu: widget.father.PluChild!,
                            height: hasMinWidth(context) ? 140 : 70,
                            width: hasMinWidth(context) ? 140 : 70,
                            isAlcoholic: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FatherNameText(name: widget.father.ChildName!),
                            QuantityText(
                              quantity: widget.father.Quantity!,
                            ),
                            // PriceText(
                            //   quantity: productCompositionPresenter
                            //       .calculateTotalLiquid(
                            //           product: widget.father),
                            // ),
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
                        GestureDetector(
                          onTap: () {
                            final dynamic tooltip = _tooltipKey.currentState;
                            tooltip.ensureTooltipVisible();
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0),
                                child: Tooltip(
                                  key: _tooltipKey,
                                  message: 'Esse produto é obrigatório',
                                  child: Icon(
                                    Icons.info,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor,
                                  ),
                                ),
                              ),
                              Text(
                                "Item obrigatório",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      Theme.of(context).secondaryHeaderColor,
                                  fontSize: getStringSize(context),
                                ),
                              ),
                            ],
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
