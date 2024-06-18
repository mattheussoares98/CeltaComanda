import 'package:flutter/material.dart';

class CommentRichText extends StatelessWidget {
  final String comment;
  const CommentRichText({
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Comentário: ",
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
              fontSize: 17,
            ),
          ),
          TextSpan(
            text: comment,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
