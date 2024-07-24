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
    return Text(
      comment.replaceAll(RegExp(r'\n'), '; '),
      style: TextStyle(
        color: Theme.of(context).primaryColorLight,
        fontStyle: FontStyle.italic,
        fontSize: getStringSize(context) * 0.7,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
