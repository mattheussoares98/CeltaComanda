import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class Comment extends StatelessWidget {
  final String? comment;
  const Comment({
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (comment == null || comment!.isEmpty == true) {
      return const SizedBox();
    }

    return Text(
      comment!.replaceAll(RegExp(r'\n'), '; '),
      style: TextStyle(
        color: Theme.of(context).primaryColorLight,
        fontStyle: FontStyle.italic,
        fontSize: StringSize.size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
