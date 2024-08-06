import 'package:flutter/material.dart';

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
          return "Digite o código do usuário";
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: "Código do usuário",
        labelText: "Código do usuário",
      ),
    );
  }
}
