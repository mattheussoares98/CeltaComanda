import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../presentation/presenters/presenters.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  void _requestFocusToFormField() {
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> _searchProduct(
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter,
  ) async {
    if (!formKey.currentState!.validate()) {
      _requestFocusToFormField();
      return;
    }

    await expansibleGroupsPresenter.searchProduct(controller.text);

    if (expansibleGroupsPresenter.searchedProduct != null) {
      controller.clear();
    } else {
      _requestFocusToFormField();
    }
  }

  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: controller,
                    maxLength: 13,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) async {
                      await _searchProduct(expansibleGroupsPresenter);
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
                          controller.clear();
                          _requestFocusToFormField();
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async => await expansibleGroupsPresenter
                      .readBarcodeAndSearchProduct(),
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              IconButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      _requestFocusToFormField();
                    } else {
                      await _searchProduct(expansibleGroupsPresenter);
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
