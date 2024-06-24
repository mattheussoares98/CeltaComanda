import '../../../helpers/helpers.dart';
import '../comments.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLocalCommentButton extends StatelessWidget {
  const AddLocalCommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<CommentsPresenter>(context);
    return ElevatedButton(
      onPressed: () async {
        await presenter.addComment(CommentViewModel(
          comment: "novo",
          selected: false,
        ));
      },
      child: Text(R.string.validateEnterprise.toUpperCase()),
    );
  }
}
