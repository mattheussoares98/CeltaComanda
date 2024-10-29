import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class CovenantPage extends StatefulWidget {
  final CovenantPresenter covenantPresenter;
  const CovenantPage({
    required this.covenantPresenter,
    super.key,
  });

  @override
  State<CovenantPage> createState() => _CovenantPageState();
}

class _CovenantPageState extends State<CovenantPage>
    with LoadingManager, UIErrorManager {
  final textController = TextEditingController();
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  bool _searchByPersonalizedCode = false;

  @override
  void dispose() async {
    super.dispose();

    textController.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    await widget.covenantPresenter.updateSelectedCovenant(null, "");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.covenantPresenter.updateSelectedCovenant(null, "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.covenantPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.covenantPresenter.mainErrorStream);

    return PopScope(
      canPop: false,
      child: ListenableProvider(
        create: (_) => widget.covenantPresenter,
        child: Scaffold(
          appBar: AppBar(
            title: Text(R.string.covenant),
            leading: const PersonalizedLeadingAppbar(),
          ),
          body: StreamBuilder<List<CustomerViewModel>?>(
              stream: widget.covenantPresenter.customersViewModelStream,
              builder: (context, snapshotCustomers) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: StreamBuilder<ValidationError?>(
                            stream:
                                widget.covenantPresenter.customerErrorStream,
                            builder: (context, snapshotCustomerError) {
                              return Column(
                                children: [
                                  GetCustomerField(
                                    textController: textController,
                                    errorText:
                                        snapshotCustomerError.data?.description,
                                    searchByPersonalizedCode:
                                        _searchByPersonalizedCode,
                                    customers: snapshotCustomers.hasData
                                        ? snapshotCustomers.data!
                                        : [],
                                  ),
                                  const SizedBox(height: 5),
                                  CheckboxListTile(
                                      value: _searchByPersonalizedCode,
                                      dense: true,
                                      contentPadding: EdgeInsets.only(left: 4),
                                      tileColor: Theme.of(context)
                                          .primaryColorLight
                                          .withAlpha(30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      title: FittedBox(
                                        child: Text(
                                          R.string.searchByPersonalizedCode,
                                          style: TextStyle(
                                            fontSize: getStringSize(context),
                                          ),
                                        ),
                                      ),
                                      onChanged: (_) {
                                        setState(() {
                                          _searchByPersonalizedCode =
                                              !_searchByPersonalizedCode;
                                        });
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "${R.string.missing}: ${paymentPresenter.getTotalPendingValue(printedProductsPresenter).toString().toBrazilianNumber().addBrazilianCoin()}",
                                      style: TextStyle(
                                        fontSize: getStringSize(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 0.3),
                                ],
                              );
                            },
                          ),
                        ),
                        Customers(customers: snapshotCustomers.data ?? []),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
