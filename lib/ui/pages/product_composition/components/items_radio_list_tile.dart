import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/pages/pages.dart';

class ItemsRadioListTile extends StatefulWidget {
  final ProductCompositionViewModel father;
  final bool isFixedItemInCombox;
  final FocusNode commentFocusNode;
  final Function() changeFocusToCommentFocusNode;
  final Function() updateSelectedIndex;
  final Function() updateShowCommentFormField;
  final int index;
  final int selectedIndex;
  final List<ProductCompositionViewModel> productsCompositionsViewModel;
  const ItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.commentFocusNode,
    required this.changeFocusToCommentFocusNode,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.updateShowCommentFormField,
    required this.productsCompositionsViewModel,
    super.key,
  });

  @override
  State<ItemsRadioListTile> createState() => _ItemsRadioListTileState();
}

class _ItemsRadioListTileState extends State<ItemsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount:
              widget.isFixedItemInCombox ? 1 : widget.father.childs?.length,
          itemBuilder: (context, childIndex) {
            final child = widget.isFixedItemInCombox
                ? widget.father
                : widget.father.childs?[childIndex];

            if (widget.isFixedItemInCombox &&
                widget.father.IsOptionalItem == "false") {
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
                        plu: child!.PluChild!,
                        showLargeImageInShowDialog: true,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (child.ChildName != null)
                              Text(
                                child.ChildName!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (child.Quantity != null)
                              Text(
                                  "Quantidade ${child.Quantity!.toBrazilianNumber()}"),
                            if (widget.isFixedItemInCombox)
                              if (widget.father.IncrementValue
                                      .toString()
                                      .toDouble() >
                                  0)
                                Column(
                                  children: [
                                    const Text(
                                      "+",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Text(
                                      "Acréscimo: ${widget.father.IncrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isFixedItemInCombox)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            child.IsOptionalItem == "true"
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
                            updateShowCommentFormField:
                                widget.updateShowCommentFormField,
                            changeFocusToCommentFocusNode:
                                widget.changeFocusToCommentFocusNode,
                          ),
                        ],
                      ),
                      CommentFormField(
                        father: widget.father,
                        commentFocusNode: widget.commentFocusNode,
                        changeFocusToCommentFocusNode:
                            widget.changeFocusToCommentFocusNode,
                        updateSelectedIndex: widget.updateSelectedIndex,
                        index: widget.index,
                        selectedIndex: widget.selectedIndex,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
