import 'package:flutter/material.dart';

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
  const ItemsRadioListTile({
    required this.father,
    required this.isFixedItemInCombox,
    required this.commentFocusNode,
    required this.changeFocusToCommentFocusNode,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.updateShowCommentFormField,
    super.key,
  });

  @override
  State<ItemsRadioListTile> createState() => _ItemsRadioListTileState();
}

class _ItemsRadioListTileState extends State<ItemsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.isFixedItemInCombox
              ? 1
              : widget.father.childs?.length,
          itemBuilder: (context, childIndex) {
            final child = widget.isFixedItemInCombox
                ? widget.father
                : widget.father.childs?[childIndex];
            return Column(
              children: [
                RadioListTile<int>(
                  value: childIndex,
                  groupValue: widget.isFixedItemInCombox &&
                          widget.father.IsOptionalItem == "false"
                      //se o item for obrigatório, já seleciona ele automaticamente e não deixa retirar a seleção
                      ? 0
                      : widget.father.indexOfSelectedChild,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.trailing,
                  toggleable:
                      widget.father.IsOptionalItem == "true",
                  onChanged: (int? value) {
                    setState(() {
                      widget.father.indexOfSelectedChild = value;
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
                      if (child?.PluChild != null)
                        Text("PLU ${child!.PluChild!}"),
                      if (child?.Quantity != null)
                        Text(
                            "Quantidade ${child!.Quantity!.toBrazilianNumber()}"),
                      Text(child?.OfferPrice != null &&
                              child?.OfferPrice! == "0.0"
                          ? "Preço ${child?.SalePrice!.toBrazilianNumber()}"
                              .addBrazilianCoin()
                          : "Preço ${child?.OfferPrice!.toBrazilianNumber()}"
                              .addBrazilianCoin()),
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
                            child?.IsOptionalItem == "true"
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
