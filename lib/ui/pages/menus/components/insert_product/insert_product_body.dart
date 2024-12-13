import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';

class InsertProductBody extends StatefulWidget {
  const InsertProductBody({super.key});

  @override
  State<InsertProductBody> createState() => _InsertProductBodyState();
}

class _InsertProductBodyState extends State<InsertProductBody> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final productFormKey = GlobalKey<FormState>();
  final commandNumberFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final commandNumberController = TextEditingController();
  final quantityController = TextEditingController();
  final commentController = TextEditingController();
  bool searchedProduct = false;

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    searchProductController.dispose();
    commandNumberController.dispose();
    quantityController.dispose();
    commentController.dispose();
  }

  void _requestFocusToFormField() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> _searchProduct(MenuPresenter menuPresenter) async {
    if (!formKey.currentState!.validate()) {
      _requestFocusToFormField();
      return;
    }

    await menuPresenter.searchProduct(searchProductController.text);
    searchedProduct = true;

    focusNode.unfocus();
    searchProductController.clear();
    quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
            changeSearchedProduct: () {
              searchedProduct = true;
            },
          ),
          StreamBuilder<ProductsViewModel?>(
            stream: menuPresenter.searchedProductStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox();
              }

              if (searchedProduct && searchProductController.text.isNotEmpty) {
                Future.delayed(Duration.zero, () {
                  searchedProduct = false;
                  searchProductController.text = "";
                });
              }

              return SearchedProduct(
                product: snapshot.data!,
                commandNumberController: commandNumberController,
                quantityController: quantityController,
                commentController: commentController,
              );
            },
          ),
        ],
      ),
    );
  }
}
