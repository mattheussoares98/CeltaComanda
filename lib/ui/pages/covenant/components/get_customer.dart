import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GetCustomer extends StatelessWidget {
  final TextEditingController textController;
  final CovenantPresenter covenantPresenter;
  const GetCustomer({
    required this.covenantPresenter,
    required this.textController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UIError?>(
        stream: covenantPresenter.mainErrorStream,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: R.string.enterprise,
                    suffixIcon: Icon(Icons.search,
                        color: Theme.of(context).primaryColor),
                    errorText: snapshot.data?.description,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: textController,
                  onFieldSubmitted: (_) async {},
                  onChanged: (value) {},
                ),
              ),
              TextButton(
                onPressed: () async {
                  await covenantPresenter.getCustomer(textController.text);
                },
                child: const Text("Get customer create helper"),
              )
            ],
          );
        });
  }
}
