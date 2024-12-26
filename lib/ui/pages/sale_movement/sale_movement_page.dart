import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SaleMovementPage extends StatefulWidget {
  const SaleMovementPage({super.key});

  @override
  State<SaleMovementPage> createState() => _SaleMovementPageState();
}

class _SaleMovementPageState extends State<SaleMovementPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                Text(selectedDate == null
                    ? R.string.selectDate
                    : formatDate(selectedDate!, [yyyy, '-', mm, '-', dd])),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: selectedDate == null
                ? null
                : () async {
                    await saleMovementPresenter.loadSales(
                      date: selectedDate!.toIso8601String(),
                    );
                  },
            child: const Text('Load Sales'),
          ),
        ],
      ),
    );
  }
}
