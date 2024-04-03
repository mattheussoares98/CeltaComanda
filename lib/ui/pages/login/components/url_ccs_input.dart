import '../../../helpers/helpers.dart';
import '../login.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UrlCcsInput extends StatelessWidget {
  const UrlCcsInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.urlErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.string.url,
              icon: Icon(Icons.http, color: Theme.of(context).primaryColor),
              errorText: snapshot.data?.description,
            ),
            focusNode: presenter.urlFocusNode,
            onChanged: presenter.validateUrl,
          );
        });
  }
}
