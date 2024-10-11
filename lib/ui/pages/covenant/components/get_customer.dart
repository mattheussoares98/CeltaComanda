// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GetCustomer extends StatelessWidget {
  final TextEditingController textController;

  const GetCustomer({
    required this.textController,
    super.key,
  });

  Future<void> getCustomer(
    CovenantPresenter covenantPresenter,
    BuildContext context,
  ) async {
    if (covenantPresenter.authorizationPendingModel?.isPending == true) {
      notificationDialog(
          context: context,
          titleMessage: R.string.msgAuthorizationIsPendant,
          content: Text(R.string.msgPendantAuthorizationNotification),
          onPress: () async {
            await covenantPresenter.getCustomer(textController.text);
          });
    } else {
      await covenantPresenter.getCustomer(textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: StreamBuilder<ValidationError?>(
          stream: covenantPresenter.customerErrorStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.codeNameOrCpf,
                      labelText: R.string.codeNameOrCpf,
                      errorText: snapshot.data?.description,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            await getCustomer(covenantPresenter, context);
                          },
                          icon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textController,
                    onFieldSubmitted: (_) async {
                      await getCustomer(covenantPresenter, context);
                    },
                    onChanged: (value) => covenantPresenter
                        .validateCustomerField(textController.text),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await getCustomer(covenantPresenter, context);
                  },
                  child: Text(R.string.getCustomer),
                )
              ],
            );
          }),
    );
  }
}
