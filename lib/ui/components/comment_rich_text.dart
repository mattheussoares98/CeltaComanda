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
            style: Theme.of(context).textTheme.titleMedium,
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
