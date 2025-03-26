import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class WriteCpfCnpjField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cpfCnpjController;
  final FocusNode cpfCnpjFocusNode;
  const WriteCpfCnpjField({
    super.key,
    required this.formKey,
    required this.cpfCnpjController,
    required this.cpfCnpjFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: hasMinWidth(context)
            ? MediaQuery.of(context).size.width * 0.3
            : MediaQuery.of(context).size.width * 0.6,
        child: TextFormField(
          controller: cpfCnpjController,
          focusNode: cpfCnpjFocusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [LengthLimitingTextInputFormatter(14)],
          onChanged: paymentPresenter.changeCpfCnpj,
          decoration: formFieldDecoration(
            context: context,
            hintText: R.string.cpfCnpjInFiscalNote,
            labelText: R.string.cpfCnpjInFiscalNote,
            errorText: null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            } else if (value.length != 11 && value.length != 14) {
              return R.string.msgInvalidCpfCnpj;
            } else if (value.length == 11 && CPFValidator.isValid(value)) {
              return null;
            } else if (value.length == 14 && CNPJValidator.isValid(value)) {
              return null;
            }

            return R.string.msgInvalidCpfCnpj;
          },
          onFieldSubmitted: (_) async {
            if (formKey.currentState?.validate() != true) {
              return;
            }
          },
        ),
      ),
    );
  }
}
