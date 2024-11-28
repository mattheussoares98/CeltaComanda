import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LoadedProductsItems extends StatelessWidget {
  const LoadedProductsItems({super.key});

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<PrintedViewModel?>(
        stream: sendProductsToAnotherTablePresenter.printedProducts,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "origin table is empty" + "",
                style: TextStyle(
                  fontSize: getStringSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }
          if (snapshot.data == null) {
            return SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: hasMinWidth(context) ? 3 : 1,
                childAspectRatio: 8,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: snapshot.data!.Products.length,
              itemBuilder: (context, index) {
                snapshot.data!.Products.sort((a, b) =>
                    a.DateHourOfCreation.compareTo(b.DateHourOfCreation));

                final product = snapshot.data!.Products[index];

                DateTime data = DateTime.parse(product.DateHourOfCreation);
                String horasEMinutos =
                    "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

                return InkWell(
                  onTap: () {},
                  child: Container(
                    color: Theme.of(context).primaryColorLight.withAlpha(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(horasEMinutos),
                        ),
                        Text(product.Product.Name),
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
