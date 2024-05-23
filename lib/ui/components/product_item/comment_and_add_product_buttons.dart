import 'package:flutter/material.dart';

import '../components.dart';

class CommentAndAddProductButtons extends StatefulWidget {
  final Function() updateSelectedIndex;
  final int index;
  final int selectedIndex;
  final TextEditingController commentTextController;
  final Function() changeFocusToCommentFocusNode;
  final bool isConfirmedComment;
  final Function() updateIsConfirmendCommentToFalse;
  final Function() clearProductQuantity;
  final Function() updateSaleRequest;

  const CommentAndAddProductButtons({
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.commentTextController,
    required this.changeFocusToCommentFocusNode,
    required this.isConfirmedComment,
    required this.updateIsConfirmendCommentToFalse,
    required this.clearProductQuantity,
    required this.updateSaleRequest,
    super.key,
  });

  @override
  State<CommentAndAddProductButtons> createState() =>
      _CommentAndAddProductButtonsState();
}

class _CommentAndAddProductButtonsState
    extends State<CommentAndAddProductButtons> {
  void _clearDataOnSuccess() {
    widget.commentTextController.clear();
    widget.updateIsConfirmendCommentToFalse();
    widget.updateSelectedIndex();
    widget.clearProductQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            widget.updateSelectedIndex();

            if (widget.index != widget.selectedIndex) {
              widget.commentTextController.clear();

              await widget.changeFocusToCommentFocusNode();
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 3, 0, 3),
            child: Row(
              children: [
                Icon(
                  widget.isConfirmedComment ? Icons.edit : Icons.add_comment,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "Comentário",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Text(
            "Adicionar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            if (widget.commentTextController.text.isNotEmpty &&
                !widget.isConfirmedComment) {
              notificationDialog(
                context: context,
                titleMessage: "Inserir produto sem comentário",
                content: const Text(
                    "Deseja realmente inserir o produto sem confirmar o comentário?"),
                onPress: () async {
                  try {
                    await widget.updateSaleRequest();
                    _clearDataOnSuccess();
                  } catch (e) {
                    e;
                  }
                },
              );
            } else {
              try {
                await widget.updateSaleRequest();
                _clearDataOnSuccess();
              } catch (e) {
                e;
              }
            }
          },
        ),
      ],
    );
  }
}
