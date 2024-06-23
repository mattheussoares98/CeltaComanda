import '../../../helpers/helpers.dart';
import '../comments.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLocalCommentButton extends StatelessWidget {
  const AddLocalCommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<CommentsPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true
                ? () async {
                    presenter.addComment("passar o comentario correto aqui");
                  }
                : null,
            child: Text(R.string.validateEnterprise.toUpperCase()),
          );
        });
  }
}
