import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
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
            text: "Comentários: \n",
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
              fontSize: hasMinWidth(context) ? 25 : 17,
            ),
          ),
          TextSpan(
            text: comment.replaceAll(RegExp(r'\n'), '; '),
            style: TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: hasMinWidth(context) ? 25 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
