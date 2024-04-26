import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  final PrintedProductsPresenter presenter;
  const PrintedProductsPage({
    required this.presenter,
    super.key,
  });

  @override
  State<PrintedProductsPage> createState() => _PrintedProductsPageState();
}

class _PrintedProductsPageState extends State<PrintedProductsPage>
    with LoadingManager {
  @override
  Widget build(BuildContext context) {
    final expansibleGroupsPresenter = Provider.of<GetxExpansibleGroupsPresenter>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Produtos impressos"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, expansibleGroupsPresenter.isLoadingStream);

                  if (expansibleGroupsPresenter.printedProducts != null) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: PrintedProduct(
                        printed: expansibleGroupsPresenter.printedProducts!,
                      ),
                    );
                  }
                  return const Text("Não há dados");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
