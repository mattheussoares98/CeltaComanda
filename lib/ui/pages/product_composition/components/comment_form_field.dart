import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class CommentFormField extends StatefulWidget {
  final Function() changeFocusToCommentFocusNode;
  final Function() updateSelectedIndex;
  final int index;
  final int selectedIndex;
  final ProductCompositionViewModel father;
  final FocusNode commentFocusNode;

  const CommentFormField({
    required this.changeFocusToCommentFocusNode,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.father,
    required this.commentFocusNode,
    super.key,
  });

  @override
  State<CommentFormField> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentFormField> {
  final formKey = GlobalKey<FormState>();
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.index == widget.selectedIndex ||
              widget.father.commentFather != ""
          ? const EdgeInsets.fromLTRB(8, 0, 0, 3)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.index == widget.selectedIndex)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  focusNode: widget.commentFocusNode,
                  controller: commentTextController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Digite algo para confirmar";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: TextButton(
                      onPressed: () async {
                        bool isValid = formKey.currentState!.validate();
                        if (!isValid) {
                          await widget.changeFocusToCommentFocusNode();
                        } else {
                          widget.updateSelectedIndex();
                          widget.father.commentFather =
                              commentTextController.text;
                          commentTextController.clear();
                        }
                      },
                      child: const Text(
                        "confirmar\ncomentário",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    hintText: "Comentário",
                    label: const Text("Comentário"),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 8,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.father.commentFather != null)
            CommentRichText(comment: widget.father.commentFather!),
        ],
      ),
    );
  }
}
