import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../pages/pages.dart';
import 'image.dart';

void showLargeImage({
  required BuildContext context,
  required String? ean,
  required String? productComplement,
  ProductsViewModel? selectedProduct,
  bool? showInsertButton,
  required String plu,
  required MenuPresenter menuPresenter,
  String? productName,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (MediaQuery.of(context).orientation == Orientation.landscape &&
            MediaQuery.of(context).size.width > 600) {
          return _landScapeLargeImage(
            context: context,
            ean: ean,
            productComplement: productComplement,
            plu: plu,
            selectedProduct: selectedProduct,
            menuPresenter: menuPresenter,
            showInsertButton: showInsertButton,
            productName: productName,
          );
        } else {
          return _portraitLargeImage(
            menuPresenter: menuPresenter,
            context: context,
            ean: ean,
            productComplement: productComplement,
            selectedProduct: selectedProduct,
            showInsertButton: showInsertButton,
            plu: plu,
            productName: productName,
          );
        }
      });
}

Widget _portraitLargeImage({
  required BuildContext context,
  required String? ean,
  required String? productComplement,
  required ProductsViewModel? selectedProduct,
  required bool? showInsertButton,
  required String plu,
  required MenuPresenter menuPresenter,
  required String? productName,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const CircleAvatar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.close,
            size: 40,
          ),
        ),
      ),
      Expanded(
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (productName != null)
                Text(
                  productName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: hasMinWidth(context) ? 40 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (productComplement != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(productComplement),
                      ],
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: ImageWidget(
                  ean: ean,
                  plu: plu,
                  productComplement: productComplement,
                  showLargeImageInShowDialog: false,
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(height: 10),
              if (selectedProduct != null &&
                  showInsertButton == true &&
                  selectedProduct.IsPromoCombox == "false")
                InsertProductButton(
                  selectedProduct: selectedProduct,
                  popScreen: true,
                ),
              _addComboxButton(
                selectedProduct: selectedProduct,
                context: context,
                menuPresenter: menuPresenter,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _landScapeLargeImage({
  required BuildContext context,
  required String? ean,
  required String? productComplement,
  required ProductsViewModel? selectedProduct,
  required String plu,
  required MenuPresenter menuPresenter,
  required bool? showInsertButton,
  required String? productName,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 5,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          content: Column(
            children: [
              if (productName != null)
                Text(
                  productName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: hasMinWidth(context) ? 40 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ImageWidget(
                        ean: ean,
                        plu: plu,
                        productComplement: productComplement,
                        showLargeImageInShowDialog: false,
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    if (productComplement != null)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(productComplement),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (selectedProduct != null &&
                  showInsertButton == true &&
                  selectedProduct.IsPromoCombox == "false")
                InsertProductButton(
                  selectedProduct: selectedProduct,
                  popScreen: true,
                ),
              _addComboxButton(
                selectedProduct: selectedProduct,
                context: context,
                menuPresenter: menuPresenter,
              ),
            ],
          ),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const CircleAvatar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.close,
            size: 40,
          ),
        ),
      ),
    ],
  );
}

Widget _addComboxButton({
  required ProductsViewModel? selectedProduct,
  required BuildContext context,
  required MenuPresenter menuPresenter,
}) {
  if (selectedProduct != null && selectedProduct.IsPromoCombox == "true") {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        maximumSize: const Size(double.infinity, 60),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        menuPresenter.goToComboxPage(selectedProduct);
      },
      child: const FittedBox(
        child: Text("Escolher produtos do combo",
            style: TextStyle(
              fontSize: 60,
            )),
      ),
    );
  } else {
    return const SizedBox();
  }
}
