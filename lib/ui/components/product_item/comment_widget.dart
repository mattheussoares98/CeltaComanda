import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final FocusNode commentFocusNode;
  final TextEditingController commentTextController;
  final Function() changeFocusToCommentFocusNode;
  final Function() updateSelectedIndex;
  final Function() updateConfirmedComment;
  final int index;
  final int selectedIndex;
  final String confirmedComment;

  const CommentWidget({
    required this.commentFocusNode,
    required this.commentTextController,
    required this.changeFocusToCommentFocusNode,
    required this.updateConfirmedComment,
    required this.updateSelectedIndex,
    required this.index,
    required this.selectedIndex,
    required this.confirmedComment,
    super.key,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.index == widget.selectedIndex || widget.confirmedComment != ""
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
                  controller: widget.commentTextController,
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
                          widget.updateConfirmedComment();
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
          if (widget.confirmedComment != "")
            CommentRichText(comment: widget.confirmedComment),
        ],
      ),
    );
  }
}
