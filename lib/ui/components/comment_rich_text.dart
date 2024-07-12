import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

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
            text: "Comentários: ",
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
              fontSize: getStringSize(context),
            ),
          ),
          TextSpan(
            text: comment.replaceAll(RegExp(r'\n'), '; '),
            style: TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: getStringSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
