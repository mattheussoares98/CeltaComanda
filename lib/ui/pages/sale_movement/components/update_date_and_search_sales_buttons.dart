import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateDateAndSearchSalesButtons extends StatefulWidget {
  const UpdateDateAndSearchSalesButtons({super.key});

  @override
  State<UpdateDateAndSearchSalesButtons> createState() =>
      _UpdateDateAndSearchSalesButtonsState();
}

class _UpdateDateAndSearchSalesButtonsState
    extends State<UpdateDateAndSearchSalesButtons> {
  DateTime? selectedDate;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        selectedDate = DateTime.now();
      }
    });
  }

  String formatedDate() {
    if (selectedDate == null) {
      return formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
    } else {
      return formatDate(selectedDate!, [dd, '/', mm, '/', yyyy]);
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              selectedDate = await GetNewDate.get(
                insertHoursAndMinutes: false,
                reduceDaysFromInitialDate: 90,
              );
              setState(() {});
            },
            child: Text(
              "${formatedDate()}   ${R.string.changeDate}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await saleMovementPresenter.loadSales(
                date: selectedDate!.toIso8601String(),
              );
            },
            child: Text(R.string.loadSales),
          ),
        ),
      ],
    );
  }
}
