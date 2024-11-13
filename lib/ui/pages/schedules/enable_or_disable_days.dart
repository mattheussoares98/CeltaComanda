import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        MenuPresenter menuPresenter = Provider.of(context, listen: false);
        menuPresenter.updateProductSchedule(
          internalCodeOnErp: widget.product.InternalCodeOfProductOnERP!.toInt(),
          monday: widget.product.Schedule?.AllowMonday != false,
          tuesday: widget.product.Schedule?.AlloTuesday != false,
          wednesday: widget.product.Schedule?.AllowWednesday != false,
          thursday: widget.product.Schedule?.AllowThursday != false,
          friday: widget.product.Schedule?.AllowFriday != false,
          saturday: widget.product.Schedule?.AllowSaturday != false,
          sunday: widget.product.Schedule?.AllowSunday != false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return StreamBuilder<ProductScheduleViewModel?>(
        stream: menuPresenter.productScheduleStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Text(
                widget.product.Name,
                style: TextStyle(
                  fontSize: getStringSize(context) * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                  title: Text(R.string.monday),
                  value: snapshot.data?.AllowMonday == true,
                  fillColor: snapshot.data?.AllowMonday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      monday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.tuesday),
                  value: snapshot.data?.AlloTuesday == true,
                  fillColor: snapshot.data?.AlloTuesday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      tuesday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.wednesday),
                  value: snapshot.data?.AllowWednesday == true,
                  fillColor: snapshot.data?.AllowWednesday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      wednesday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.thursday),
                  value: snapshot.data?.AllowThursday == true,
                  fillColor: snapshot.data?.AllowThursday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      thursday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.friday),
                  value: snapshot.data?.AllowFriday == true,
                  fillColor: snapshot.data?.AllowFriday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      friday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.saturday),
                  value: snapshot.data?.AllowSaturday == true,
                  fillColor: snapshot.data?.AllowSaturday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      saturday: value,
                    );
                  }),
              CheckboxListTile(
                  title: Text(R.string.sunday),
                  value: snapshot.data?.AllowSunday == true,
                  fillColor: snapshot.data?.AllowSunday == true
                      ? WidgetStatePropertyAll(Colors.green)
                      : null,
                  onChanged: (value) {
                    menuPresenter.updateProductSchedule(
                      internalCodeOnErp:
                          widget.product.InternalCodeOnERP!.toInt(),
                      sunday: value,
                    );
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
                        onPressed: snapshot.data == null
                            ? null
                            : () async {
                                await menuPresenter.insertUpdateProductSchedule(
                                  widget.product.InternalCodeOnERP!.toInt(),
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
        });
  }
}
