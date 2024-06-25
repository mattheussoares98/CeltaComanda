import 'package:flutter/material.dart';

import '../../../components/components.dart';

class Comment extends StatefulWidget {
  final String? comments;
  final Future<void> Function() clearComment;
  final Future<void> Function() updateComment;

  const Comment({
    required this.comments,
    required this.clearComment,
    required this.updateComment,
    super.key,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  FocusNode commentsFocusNode = FocusNode();

  void onTapCommentIcon() {}

  @override
  void dispose() {
    super.dispose();
    commentsFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapCommentIcon,
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
        ),
      ],
    );
  }
}
