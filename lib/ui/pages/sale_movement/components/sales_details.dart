import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class SalesDetails extends StatelessWidget {
  const SalesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder(
      stream: saleMovementPresenter.salesStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SizedBox();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final sale = snapshot.data![index];

            return Text(sale.TotalLiquid.toString());
          },
        );
      },
    );
  }
}
