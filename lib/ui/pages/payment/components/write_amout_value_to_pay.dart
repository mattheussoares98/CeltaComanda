import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class WriteAmoutValueToPay extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController paymentController;
  final FocusNode paymentFocusNode;
  const WriteAmoutValueToPay({
    required this.formKey,
    required this.paymentController,
    required this.paymentFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return SizedBox(
      width: hasMinWidth(context)
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.width * 0.6,
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: paymentController,
          focusNode: paymentFocusNode,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return R.string.msgWritePaymentValue;
            } else if (value.toDouble() == -1.0) {
              return R.string.msgInvalidNumber;
            } else if (value.toDouble() >
                paymentPresenter
                    .getTotalPendingValue(printedProductsPresenter)) {
              return R.string.msgInvalidNumber;
            } else if (value.toDouble() < 0.01) {
              return R.string.msgInvalidNumber;
            } else if (value.toDouble().toString().split('.')[1].length > 2) {
              return R.string.msgInvalidNumber;
            }
            return null;
          },
          decoration: formFieldDecoration(
            context: context,
            hintText: R.string.paymentValue.addBrazilianCoin(),
            labelText: R.string.paymentValue.addBrazilianCoin(),
            errorText: null,
            suffixIcon: IconButton(
              onPressed: () {
                paymentController.clear();
                paymentFocusNode.requestFocus();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
