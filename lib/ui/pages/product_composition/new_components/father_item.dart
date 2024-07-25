import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final String title;
  final bool isOptional;
  final int indexOfSelectedFather;
  final bool fatherIsSelected;
  final ProductsViewModel selectedProduct;
  const FatherItem({
    required this.title,
    required this.isOptional,
    required this.indexOfSelectedFather,
    required this.fatherIsSelected,
    required this.selectedProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        productCompositionPresenter.updateSelectedFatherIndex(
          newIndex: indexOfSelectedFather,
          atualFather:
              selectedProduct.childsComposition![indexOfSelectedFather],
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Container(
          color: fatherIsSelected
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOptional ? "Opcional" : "Obrigatório",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getStringSize(context) * 0.7,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
