import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchCustomerField extends StatelessWidget {
  final bool searchByPersonalizedCode;
  final TextEditingController controller;
  final FocusNode focusNode;
  const SearchCustomerField({
    super.key,
    required this.searchByPersonalizedCode,
    required this.controller,
    required this.focusNode,
  });

  Future<void> loadCustomers(
    PrintedProductsPresenter printedProductsPresenter,
    BuildContext context,
  ) async {
    await printedProductsPresenter.getCustomers(
      value: controller.text,
      showErrorMessageReturnedByBs: (error) {
        snackBarMessage(context, error, backgroundColor: Colors.red);
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
      focusNode: focusNode,
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
