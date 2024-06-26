import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../comments.dart';

class AddCommentFormField extends StatefulWidget {
  const AddCommentFormField({super.key});

  @override
  State<AddCommentFormField> createState() => _AddCommentFormFieldState();
}

class _AddCommentFormFieldState extends State<AddCommentFormField> {
  final commentsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Form(
      child: TextFormField(
        controller: commentsController,
        decoration: const InputDecoration(
            hintText: "Adicionar comentário",
            labelText: "Adicionar comentário"),
        onFieldSubmitted: (value) async {
          await commentsPresenter.addComment(
            CommentViewModel(
              comment: commentsController.text,
              selected: true,
            ),
          );

          commentsController.clear();
        },
      ),
    );
  }
}
