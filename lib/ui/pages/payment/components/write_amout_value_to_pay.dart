import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class WriteAmoutValueToPay extends StatefulWidget {
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
  State<WriteAmoutValueToPay> createState() => _WriteAmoutValueToPayState();
}

class _WriteAmoutValueToPayState extends State<WriteAmoutValueToPay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
      PrintedProductsPresenter printedProductsPresenter =
          Provider.of(context, listen: false);
      if (mounted &&
          paymentPresenter.getTotalPendingValue(printedProductsPresenter) > 0) {
        widget.paymentController.text = paymentPresenter
            .getTotalPendingValue(printedProductsPresenter)
            .toStringAsFixed(2)
            .toBrazilianNumber();
      }
    });
  }

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
        key: widget.formKey,
        child: TextFormField(
          controller: widget.paymentController,
          focusNode: widget.paymentFocusNode,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () {
            widget.paymentController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: widget.paymentController.text.length,
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return R.string.msgWritePaymentValue;
            } else if (value.toDouble() == -1.0) {
              return R.string.msgInvalidNumber;
            } else if (value.toDouble() >
                paymentPresenter
                    .getTotalPendingValue(printedProductsPresenter)
                    .toStringAsFixed(2)
                    .toDouble()) {
              return R.string.msgInvalidNumber;
            } else if (value.toDouble() < 0.01) {
              return R.string.msgInvalidNumber;
            } else if (value.contains(".") && value.contains(",")) {
              return R.string.msgInvalidNumber;
            }

            int pointQuantitys = 0;
            for (var x = 0; x < value.length; x++) {
              if (value[x] == ".") {
                pointQuantitys++;
              }
              if (pointQuantitys > 1) {
                return R.string.msgInvalidNumber;
              }
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
                widget.paymentController.clear();
                widget.paymentFocusNode.requestFocus();
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
