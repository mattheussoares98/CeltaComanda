import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void _requestFocusToFormField() {
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> _searchProduct(
    MenuPresenter menuPresenter,
  ) async {
    if (!formKey.currentState!.validate()) {
      _requestFocusToFormField();
      return;
    }

    await menuPresenter.searchProduct(
        menuPresenter.searchProductController.text);

    if (menuPresenter.selectedProduct == null) {
      _requestFocusToFormField();
    } else {
      focusNode.unfocus();
      menuPresenter.searchProductController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: menuPresenter.searchProductController,
                    maxLength: 13,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) async {
                      await _searchProduct(menuPresenter);
                    },
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Digite o EAN ou PLU";
                      } else if (int.tryParse(value!) == null) {
                        return "Digite somente números";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      hintText: "EAN ou PLU",
                      label: const Text("Consultar produto"),
                      labelStyle: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      counterText: "",
                      prefixIcon: IconButton(
                        onPressed: () {
                          menuPresenter.searchProductController.clear();
                          _requestFocusToFormField();
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async =>
                      await menuPresenter.readBarcodeAndSearchProduct(),
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              IconButton(
                  onPressed: () async {
                    if (menuPresenter.searchProductController.text.isEmpty) {
                      _requestFocusToFormField();
                    } else {
                      await _searchProduct(menuPresenter);
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
