import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/entities.dart';
import '../../../main/builders/builders.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class EnableOrDisableDays extends StatefulWidget {
  final ProductsViewModel product;
  const EnableOrDisableDays({
    required this.product,
    super.key,
  });

  @override
  State<EnableOrDisableDays> createState() => _EnableOrDisableDaysState();
}

class _EnableOrDisableDaysState extends State<EnableOrDisableDays> {
  bool? allowMonday;
  bool? allowTuesday;
  bool? allowWednesday;
  bool? allowThursday;
  bool? allowFriday;
  bool? allowSunday;
  bool? allowSaturday;
  List<Map<String, bool?>> days = [];

  @override
  initState() {
    super.initState();
    if (mounted) {
      allowMonday = widget.product.Schedule?.AllowMonday != false;
      allowTuesday = widget.product.Schedule?.AlloTuesday != false;
      allowWednesday = widget.product.Schedule?.AllowWednesday != false;
      allowThursday = widget.product.Schedule?.AllowThursday != false;
      allowFriday = widget.product.Schedule?.AllowFriday != false;
      allowSunday = widget.product.Schedule?.AllowSunday != false;
      allowSaturday = widget.product.Schedule?.AllowSaturday != false;
    }

    days = [
      {R.string.monday: allowMonday},
      {R.string.tuesday: allowTuesday},
      {R.string.wednesday: allowWednesday},
      {R.string.thursday: allowThursday},
      {R.string.friday: allowFriday},
      {R.string.sunday: allowSunday},
      {R.string.saturday: allowSaturday},
    ];
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Text(
          widget.product.Name,
          style: TextStyle(
            fontSize: getStringSize(context) * 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (var x = 0; x < days.length; x++)
          CheckboxListTile(
              tileColor: x % 2 == 0
                  ? Theme.of(context).primaryColor.withAlpha(50)
                  : null,
              fillColor: WidgetStatePropertyAll(
                  days[x].values.first == true ? Colors.green : null),
              title: Text(days[x].keys.first),
              value: days[x].values.first,
              onChanged: (value) {
                final newValue = value;
                setState(() {
                  days[x] = {days[x].keys.first: newValue};
                });
              }),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(R.string.cancel),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final schedule = ProductScheduleEntity(
                      InternalCodeOnERP:
                          widget.product.InternalCodeOnERP!.toInt(),
                      EnterpriseId: EnterpriseDataBuilder
                          .enterpriseDataEntity!.enterpriseId,
                      AllowMonday: allowMonday == true ? 1 : 0,
                      AlloTuesday: allowTuesday == true ? 1 : 0,
                      AllowWednesday: allowWednesday == true ? 1 : 0,
                      AllowThursday: allowThursday == true ? 1 : 0,
                      AllowFriday: allowFriday == true ? 1 : 0,
                      AllowSaturday: allowSaturday == true ? 1 : 0,
                      AllowSunday: allowSunday == true ? 1 : 0,
                    );

                    await menuPresenter.insertUpdateProductSchedule(
                      widget.product.InternalCodeOnERP!.toInt(),
                      schedule,
                    );
                  },
                  child: Text(R.string.confirm),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
