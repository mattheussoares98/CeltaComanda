import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchCustomerField extends StatelessWidget {
  final bool searchByPersonalizedCode;
  final TextEditingController controller;
  const SearchCustomerField({
    super.key,
    required this.searchByPersonalizedCode,
    required this.controller,
  });

  Future<void> loadCustomers(
    PrintedProductsPresenter printedProductsPresenter,
    BuildContext context,
  ) async {
    await printedProductsPresenter.getCustomers(
      value: controller.text,
      showErrorMessageReturnedByBs: (error) {
        snackBarMessage(context, error);
      },
      searchByPersonalizedCode: searchByPersonalizedCode,
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return TextFormField(
      autofocus: true,
      decoration: formFieldDecoration(
        errorText: null,
        context: context,
        hintText: searchByPersonalizedCode
            ? R.string.personalizedCode
            : R.string.internalcodeNameOrCpf,
        labelText: searchByPersonalizedCode
            ? R.string.personalizedCode
            : R.string.internalcodeNameOrCpf,
        suffixIcon: IconButton(
          onPressed: () async {
            await loadCustomers(printedProductsPresenter, context);
          },
          icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      onFieldSubmitted: (_) async {
        await loadCustomers(printedProductsPresenter, context);
      },
    );
  }
}
