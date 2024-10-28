import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';

class WriteAmoutValueToPay extends StatelessWidget {
  const WriteAmoutValueToPay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: hasMinWidth(context)
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: formFieldDecoration(
          context: context,
          hintText: "R.string.paymentValue" + "",
          labelText: "R.string.paymentValue" + "",
          errorText: null,
        ),
      ),
    );
  }
}
