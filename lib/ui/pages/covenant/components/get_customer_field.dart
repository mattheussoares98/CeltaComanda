import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GetCustomerField extends StatelessWidget {
  final TextEditingController textController;
  final String? errorText;
  final bool searchByPersonalizedCode;
  final List<CustomerViewModel> customers;
  const GetCustomerField({
    required this.textController,
    required this.errorText,
    required this.searchByPersonalizedCode,
    required this.customers,
    super.key,
  });

  Future<void> getCustomer(
    PaymentPresenter paymentPresenter,
    BuildContext context,
  ) async {
    if (paymentPresenter.authorizationPendingModel?.isPending == true) {
      notificationDialog(
        context: context,
        titleMessage: R.string.msgAuthorizationIsPendant,
        content: Text(R.string.msgPendantAuthorizationNotification),
        onPress: () async {
          await paymentPresenter.getCustomerByNameCodeOrCpf(
            value: textController.text,
            searchByPersonalizedCode: searchByPersonalizedCode,
            showErrorMessageReturnedByBs: (value) {
              snackBarMessage(context, value, backgroundColor: Colors.red);
            },
          );
        },
      );
    } else {
      await paymentPresenter.getCustomerByNameCodeOrCpf(
        searchByPersonalizedCode: searchByPersonalizedCode,
        value: textController.text,
        showErrorMessageReturnedByBs: (value) {
          snackBarMessage(context, value, backgroundColor: Colors.red);
        },
      );
    }

    if (customers.isNotEmpty) {
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

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
                  await getCustomer(paymentPresenter, context);
                },
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: textController,
            onFieldSubmitted: (_) async {
              await getCustomer(paymentPresenter, context);
            },
            onChanged: (value) =>
                paymentPresenter.validateCustomerField(textController.text),
          ),
        ),
        TextButton(
          onPressed: () async {
            await getCustomer(paymentPresenter, context);
          },
          child: Text(R.string.getCustomer),
        ),
      ],
    );
  }
}
