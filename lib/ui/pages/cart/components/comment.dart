import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class Comment extends StatefulWidget {
  final String? comments;
  final String productName;
  final Future Function() updateComment;

  const Comment({
    required this.comments,
    required this.productName,
    required this.updateComment,
    super.key,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Future<void> onTapCommentIcon(CommentsPresenter commentsPresenter) async {
    commentsPresenter.updateSelectedComments(widget.comments);

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: CommentsPage(
                selectedProductName: widget.productName,
              ),
            ),
          );
        });

    widget.updateComment();
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await onTapCommentIcon(commentsPresenter);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.comments == null)
                const Expanded(
                  child: Text(
                    "Adicionar comentário",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (widget.comments != null)
                Expanded(
                  child: CommentRichText(
                    comment: widget.comments!,
                  ),
                ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Icon(
                    color: Theme.of(context).colorScheme.primary,
                    widget.comments == null ? Icons.add_comment : Icons.edit,
                    size: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
