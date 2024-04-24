import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'printed_products_presenter.dart';

class PrintedProductsPage extends StatefulWidget {
  final PrintedProductsPresenter presenter;

  const PrintedProductsPage(this.presenter, {super.key});

  @override
  State<PrintedProductsPage> createState() =>
      _PrintedProductsPageState();
}

class _PrintedProductsPageState extends State<PrintedProductsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      // await widget.presenter.loadLocalData();
      // widget.presenter.validateEnterpriseInput(
      //     widget.presenter.enterpriseNameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);
          handleMainError(context, widget.presenter.mainErrorStream);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const LoginHeader(),
                  Headline1(text: R.string.validateEnterprise),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ListenableProvider(
                      create: (_) => widget.presenter,
                      child: const Form(
                        child: Column(
                          children: [
                            Text("Ainda não há dados"),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
