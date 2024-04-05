import '../../../helpers/helpers.dart';
import '../login.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInput extends StatelessWidget {
  const UserInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.userErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.string.user,
            icon:
                Icon(Icons.person, color: Theme.of(context).primaryColor),
            errorText: snapshot.data?.description,
          ),
          onFieldSubmitted: presenter.onSubmitUser,
          onChanged: presenter.validateUser,
          controller: presenter.userController,
        );
      },
    );
  }
}
