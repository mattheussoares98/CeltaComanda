import 'package:flutter/material.dart';

import '../../../components/components.dart';

class Comment extends StatefulWidget {
  final String? comments;

  const Comment({
    required this.comments,
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
                  child: CommentRichText(
                    comment: widget.comments!,
                  ),
                ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onTapCommentIcon,
                child: Row(
                  children: [
                    Icon(
                      color: Theme.of(context).colorScheme.primary,
                      widget.comments == null ? Icons.add_comment : Icons.edit,
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
