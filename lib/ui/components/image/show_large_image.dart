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
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                    if (selectedProduct != null && showInsertButton == true)
                      InsertProductButton(
                        selectedProduct: selectedProduct,
                        popScreen: true,
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
      });
}
