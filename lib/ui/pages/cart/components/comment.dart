import 'package:flutter/material.dart';

import '../../../components/components.dart';

class Comment extends StatefulWidget {
  final int indexOfProduct;
  final int? indexOfSelectedProduct;
  final String? comments;
  final void Function() updateSelectedIndex;
  final TextEditingController commentsController;
  final Future<void> Function() clearComment;
  final Future<void> Function() updateComment;

  const Comment({
    required this.indexOfProduct,
    required this.comments,
    required this.updateSelectedIndex,
    required this.indexOfSelectedProduct,
    required this.commentsController,
    required this.clearComment,
    required this.updateComment,
    super.key,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  FocusNode commentsFocusNode = FocusNode();

  void onTapCommentIcon() {
    widget.commentsController.clear();
    widget.updateSelectedIndex();
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.comments != null) {
      setState(() {
        widget.commentsController.text = widget.comments!;
      });
    }

    if (widget.indexOfSelectedProduct != widget.indexOfProduct) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(commentsFocusNode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentsFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.comments == null)
              const Expanded(
                child: Text(
                  "Não há comentário",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (widget.comments != null)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CommentRichText(
                        comment: widget.comments!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        notificationDialog(
                          context: context,
                          titleMessage: "Excluir comentário?",
                          content: null,
                          onPress: widget.clearComment,
                        );
                      },
                      child: const Icon(
                        Icons.highlight_remove_outlined,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onTapCommentIcon,
              child: Row(
                children: [
                  Icon(
                    color: Theme.of(context).colorScheme.primary,
                    Icons.add_comment,
                    size: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.indexOfSelectedProduct == widget.indexOfProduct)
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: commentsFocusNode,
                  controller: widget.commentsController,
                  maxLines: 8,
                  minLines: 1,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await widget.updateComment();

                  commentsFocusNode.unfocus();
                },
                child: const Text(
                  "Confirmar",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
      ],
    );
  }
}
