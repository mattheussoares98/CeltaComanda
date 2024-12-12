import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../pages.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    searchProductController.dispose();
  }

  void _requestFocusToFormField() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

    await menuPresenter
        .searchProduct(menuPresenter.searchProductController.text);
    //TODO remover searchController to menuPresenter

    // if (menuPresenter.selectedProductStream == null) {
    //   _requestFocusToFormField();
    // } else {
    // }
    focusNode.unfocus();
    menuPresenter.searchProductController.clear();
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        children: [
          SearchField(
            focusNode: focusNode,
            formKey: formKey,
            searchProductController: searchProductController,
            searchProduct: () async {
              await _searchProduct(menuPresenter);
            },
          ),
        ],
      ),
    );
  }
}
