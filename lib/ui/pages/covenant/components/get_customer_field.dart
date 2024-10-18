import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GetCustomerField extends StatelessWidget {
  final TextEditingController textController;
  final String? errorText;
  final bool searchByPersonalizedCode;
  const GetCustomerField({
    required this.textController,
    required this.errorText,
    required this.searchByPersonalizedCode,
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
          await covenantPresenter.getCustomerByNameCodeOrCpf(
            value: textController.text,
            searchByPersonalizedCode: searchByPersonalizedCode,
            showErrorMessageReturnedByBs: (value) {
              showAlertMessage(context, value, backgroundColor: Colors.red);
            },
          );
        },
      );
    } else {
      await covenantPresenter.getCustomerByNameCodeOrCpf(
        searchByPersonalizedCode: searchByPersonalizedCode,
        value: textController.text,
        showErrorMessageReturnedByBs: (value) {
          showAlertMessage(context, value, backgroundColor: Colors.red);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            autofocus: true,
            decoration: formFieldDecoration(
              context: context,
              hintText: searchByPersonalizedCode
                  ? R.string.personalizedCode
                  : R.string.internalcodeNameOrCpf,
              labelText: searchByPersonalizedCode
                  ? R.string.personalizedCode
                  : R.string.internalcodeNameOrCpf,
              errorText: errorText,
              suffixIcon: IconButton(
                onPressed: () async {
                  await getCustomer(covenantPresenter, context);
                },
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: textController,
            onFieldSubmitted: (_) async {
              await getCustomer(covenantPresenter, context);
            },
            onChanged: (value) =>
                covenantPresenter.validateCustomerField(textController.text),
          ),
        ),
        TextButton(
          onPressed: () async {
            await getCustomer(covenantPresenter, context);
          },
          child: Text(R.string.getCustomer),
        ),
      ],
    );
  }
}
