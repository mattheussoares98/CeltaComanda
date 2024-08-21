import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UserPersonalizedCodeInput extends StatelessWidget {
  const UserPersonalizedCodeInput({
    super.key,
    required FocusNode passwordFocusNode,
    required TextEditingController userController,
  })  : _passwordFocusNode = passwordFocusNode,
        _userController = userController;

  final FocusNode _passwordFocusNode;
  final TextEditingController _userController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (_) {
        _passwordFocusNode.requestFocus();
      },
      controller: _userController,
      validator: (value) {
        if (value?.isEmpty == true) {
          return R.string.msgWriteUserCode;
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: R.string.userCode,
        labelText: R.string.userCode,
      ),
    );
  }
}
