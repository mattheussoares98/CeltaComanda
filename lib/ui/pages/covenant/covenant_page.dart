import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class CovenantPage extends StatefulWidget {
  const CovenantPage({
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
  late PaymentPresenter paymentPresenter;

  @override
  void dispose() async {
    super.dispose();

    textController.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    await paymentPresenter.updateSelectedCustomer(null, null);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        paymentPresenter =
            Provider.of<PaymentPresenter>(context, listen: false);
        await paymentPresenter.updateSelectedCustomer(null, null);
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
        handleLoading(context, paymentPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, paymentPresenter.mainErrorStream);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.covenant),
          leading: const PersonalizedLeadingAppbar(),
        ),
        body: StreamBuilder<List<CustomerViewModel>?>(
            stream: paymentPresenter.customersViewModelStream,
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
                          stream: paymentPresenter.customerErrorStream,
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    title: FittedBox(
                                      child: Text(
                                        R.string.searchByPersonalizedCode,
                                        style: TextStyle(
                                          fontSize: StringSize.size,
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
                                      fontSize: StringSize.size,
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
    );
  }
}
