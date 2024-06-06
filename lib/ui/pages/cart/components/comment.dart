import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class Comment extends StatefulWidget {
  final int index;
  final String? comments;
  const Comment({
    required this.index,
    required this.comments,
    super.key,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocusNode = FocusNode();

  void onTapCommentIcon(CartPresenter cartPresenter) {
    cartPresenter.updateIndexOfSelectedProduct(widget.index);
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.comments != null) {
      setState(() {
        commentsController.text =
            cartPresenter.cartProducts[widget.index].Comments!;
      });
    }

    if (cartPresenter.indexOfSelectedProduct == widget.index) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(commentsFocusNode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
    commentsFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

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
                          onPress: () async {
                            await cartPresenter.updateCommentOfProductCart(
                              index: widget.index,
                              newComment: null,
                            );
                          },
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
              onTap: () {
                onTapCommentIcon(cartPresenter);
              },
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
        if (cartPresenter.indexOfSelectedProduct == widget.index)
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: commentsFocusNode,
                  controller: commentsController,
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
                  await cartPresenter.updateCommentOfProductCart(
                    index: widget.index,
                    newComment: commentsController.text,
                  );

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
