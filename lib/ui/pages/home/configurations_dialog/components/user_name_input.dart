import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UserNameInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode userNameFocusNode;
  final TextEditingController userNameController;
  const UserNameInput({
    super.key,
    required this.passwordFocusNode,
    required this.userNameFocusNode,
    required this.userNameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: userNameFocusNode,
      autofocus: true,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      controller: userNameController,
      validator: (value) {
        if (value?.isEmpty == true) {
          return R.string.msgWriteName;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: R.string.user,
        labelText: R.string.user,
      ),
    );
  }
}
