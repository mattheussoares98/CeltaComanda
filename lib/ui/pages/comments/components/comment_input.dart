import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/helpers.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<CommentsPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.mainErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.string.enterprise,
              icon: Icon(Icons.business, color: Theme.of(context).primaryColor),
              errorText: snapshot.data?.description,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // controller: presenter.enterpriseNameController,
            onFieldSubmitted: (_) async {
              await presenter.addComment(CommentViewModel(comment: "comentando", selected: false));
            },
            // onChanged: (value) => presenter.validateEnterpriseInput(value,
            //     updateEnterpriseNameController: true),
          );
        });
  }
}
