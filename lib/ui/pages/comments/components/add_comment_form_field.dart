import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../comments.dart';

class AddCommentFormField extends StatefulWidget {
  const AddCommentFormField({super.key});

  @override
  State<AddCommentFormField> createState() => _AddCommentFormFieldState();
}

class _AddCommentFormFieldState extends State<AddCommentFormField> {
  final commentsController = TextEditingController();
  final key = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    commentsController.dispose();
    focusNode.dispose();
  }

  Future<void> _addComment(CommentsPresenter commentsPresenter) async {
    bool? isValid = key.currentState?.validate();

    if (isValid != true) {
      await Future.delayed(Duration.zero);
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
      }
      return;
    }

    await commentsPresenter.addComment(
      CommentViewModel(
        comment: commentsController.text,
        selected: true,
      ),
    );

    commentsController.clear();
    Future.delayed(Duration.zero, () {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: Form(
            key: key,
            child: TextFormField(
              focusNode: focusNode,
              controller: commentsController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Digite algo";
                } else if (value!.length < 3) {
                  return "Comentário muito curto";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Novo comentário",
                labelText: "Novo comentário",
              ),
              onFieldSubmitted: (value) async {
                await _addComment(commentsPresenter);
              },
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await _addComment(commentsPresenter);
          },
          child: Text(
            "Adicionar",
            style: TextStyle(
              fontSize: hasMinWidth(context) ? 23 : 17,
            ),
          ),
        )
      ],
    );
  }
}
