import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class NavsUrlInput extends StatelessWidget {
  final TextEditingController navsUrlController;
  final FocusNode navsFocusNode;
  final FocusNode concentratorFocusNode;
  const NavsUrlInput({
    required this.navsUrlController,
    required this.navsFocusNode,
    required this.concentratorFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        focusNode: navsFocusNode,
        controller: navsUrlController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(70),
        ],
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.navsUrl,
          labelText: R.string.navsUrl,
          errorText: null,
          suffixIcon: Icon(Icons.public, color: Theme.of(context).primaryColor),
          fontSize: 14,
        ),
        onFieldSubmitted: (_) {
          concentratorFocusNode.requestFocus();
        },
        keyboardType: TextInputType.url,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.navsUrl;
          }
          return null;
        },
      ),
    );
  }
}
