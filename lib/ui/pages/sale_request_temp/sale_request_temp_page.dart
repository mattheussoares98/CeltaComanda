import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class SaleRequestTempPage extends StatefulWidget {
  const SaleRequestTempPage({super.key});

  @override
  State<SaleRequestTempPage> createState() => _SaleRequestTempPageState();
}

class _SaleRequestTempPageState extends State<SaleRequestTempPage>
    with LoadingManager {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<GetxExpansibleGroupsPresenter>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, presenter.isLoadingStream);

                  if (presenter.saleRequestTemp != null) {
                    return ProductsItems(
                        productViewModel: presenter.saleRequestTemp!);
                  }
                  return const Text("Não há dados");
                },
              ),
            ),
          ),
          const SaveSaleRequestButton(),
        ],
      ),
    );
  }
}
