import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class SaleMovementPage extends StatefulWidget {
  const SaleMovementPage({super.key});

  @override
  State<SaleMovementPage> createState() => _SaleMovementPageState();
}

class _SaleMovementPageState extends State<SaleMovementPage>
    with UIErrorManager, LoadingManager {
  DateTime? selectedDate;
  StreamSubscription? loadingSubscription;
  StreamSubscription? errorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    errorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    errorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, saleMovementPresenter.isLoadingStream);
    errorSubscription =
        handleMainError(context, saleMovementPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedDate = await GetNewDate.get(
                      insertHoursAndMinutes: false,
                      reduceDaysFromInitialDate: 90,
                    );
                    setState(() {});
                  },
                  child: Text(R.string.selectDate),
                ),
                const SizedBox(width: 20),
                Text(selectedDate == null
                    ? ""
                    : formatDate(selectedDate!, [dd, '/', mm, '/', yyyy])),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedDate == null
                  ? null
                  : () async {
                      await saleMovementPresenter.loadSales(
                        date: selectedDate!.toIso8601String(),
                      );
                    },
              child: Text(R.string.loadSales),
            ),
          ],
        ),
      ),
    );
  }
}
