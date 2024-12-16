import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchField extends StatelessWidget {
  final FocusNode focusNode;
  final GlobalKey<FormState> formKey;
  final Future<void> Function() searchProduct;
  final TextEditingController searchProductController;
  final void Function() changeSearchedProduct;
  const SearchField({
    required this.focusNode,
    required this.formKey,
    required this.searchProduct,
    required this.searchProductController,
    required this.changeSearchedProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    return Row(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: TextFormField(
              focusNode: focusNode,
              controller: searchProductController,
              maxLength: 13,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) async {
                await searchProduct();
              },
              validator: (value) {
                if (value?.isEmpty == true) {
                  return R.string.msgWriteEanOrPlu;
                } else if (int.tryParse(value!) == null) {
                  return R.string.msgWriteOnlyNumbers;
                }
                return null;
              },
              decoration: formFieldDecoration(
                context: context,
                hintText: R.string.eanOrPlu,
                labelText: R.string.searchProduct,
                errorText: null,
                showCounterText: false,
                prefixIcon: IconButton(
                  onPressed: () {
                    searchProductController.text = "";
                    focusNode.requestFocus();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                suffixIcon: Platform.isWindows
                    ? null
                    : IconButton(
                        onPressed: () async {
                          searchProductController.text =
                              await menuPresenter.readBarcodeAndSearchProduct();
                          changeSearchedProduct();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                await searchProduct();
              },
              icon: Row(
                children: [
                  Icon(
                    Icons.search,
                  ),
                  if (hasMinWidth(context))
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(R.string.searchProduct),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
