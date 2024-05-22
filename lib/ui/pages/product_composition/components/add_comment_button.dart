import 'package:flutter/material.dart';

class AddCommentButton extends StatelessWidget {
  final void Function()? updateShowCommentFormField;
  final Function() changeFocusToCommentFocusNode;

  const AddCommentButton({
    required this.updateShowCommentFormField,
    required this.changeFocusToCommentFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton.icon(
        onPressed: () {
          updateShowCommentFormField!();
          changeFocusToCommentFocusNode();
        },
        label: const Text("Comentário"),
        icon: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}
