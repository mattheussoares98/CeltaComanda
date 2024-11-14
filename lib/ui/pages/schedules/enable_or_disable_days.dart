// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class EnableOrDisableDays extends StatefulWidget {
  final ProductsViewModel? product;
  final ExpansibleGroupsViewModel? expansibleGroup;
  final bool isUpdatingProduct;
  final void Function() callSetState;
  const EnableOrDisableDays({
    required this.product,
    required this.expansibleGroup,
    required this.isUpdatingProduct,
    required this.callSetState,
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
        if (widget.isUpdatingProduct && widget.product != null) {
          menuPresenter.updateProductSchedule(
            internalCodeOnErp:
                widget.product!.InternalCodeOfProductOnERP!.toInt(),
            monday: widget.product!.Schedule?.AllowMonday != false,
            tuesday: widget.product!.Schedule?.AllowTuesday != false,
            wednesday: widget.product!.Schedule?.AllowWednesday != false,
            thursday: widget.product!.Schedule?.AllowThursday != false,
            friday: widget.product!.Schedule?.AllowFriday != false,
            saturday: widget.product!.Schedule?.AllowSaturday != false,
            sunday: widget.product!.Schedule?.AllowSunday != false,
          );
        } else {
          if (widget.expansibleGroup != null) {
            menuPresenter.updateExpansibleGroupSchedule(
              expansibleGroupId:
                  widget.expansibleGroup!.ExpansibleGroupId.toInt(),
              monday: widget.expansibleGroup!.Schedule?.AllowMonday != false,
              tuesday: widget.expansibleGroup!.Schedule?.AllowTuesday != false,
              wednesday:
                  widget.expansibleGroup!.Schedule?.AllowWednesday != false,
              thursday:
                  widget.expansibleGroup!.Schedule?.AllowThursday != false,
              friday: widget.expansibleGroup!.Schedule?.AllowFriday != false,
              saturday:
                  widget.expansibleGroup!.Schedule?.AllowSaturday != false,
              sunday: widget.expansibleGroup!.Schedule?.AllowSunday != false,
            );
          }
        }
      }
    });
  }

  void updateSchedule({
    required MenuPresenter menuPresenter,
    required ExpansibleGroupScheduleViewModel? groupSchedule,
    required ProductScheduleViewModel? productSchedule,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  }) {
    if (widget.isUpdatingProduct && widget.product != null) {
      menuPresenter.updateProductSchedule(
        internalCodeOnErp: widget.product!.InternalCodeOnERP!.toInt(),
        monday: monday ?? productSchedule?.AllowMonday,
        tuesday: tuesday ?? productSchedule?.AllowTuesday,
        wednesday: wednesday ?? productSchedule?.AllowWednesday,
        thursday: thursday ?? productSchedule?.AllowThursday,
        friday: friday ?? productSchedule?.AllowFriday,
        saturday: saturday ?? productSchedule?.AllowSaturday,
        sunday: sunday ?? productSchedule?.AllowSunday,
      );
    } else if (widget.expansibleGroup != null) {
      menuPresenter.updateExpansibleGroupSchedule(
        expansibleGroupId: widget.expansibleGroup!.ExpansibleGroupId.toInt(),
        monday: monday ?? groupSchedule?.AllowMonday,
        tuesday: tuesday ?? groupSchedule?.AllowTuesday,
        wednesday: wednesday ?? groupSchedule?.AllowWednesday,
        thursday: thursday ?? groupSchedule?.AllowThursday,
        friday: friday ?? groupSchedule?.AllowFriday,
        saturday: saturday ?? groupSchedule?.AllowSaturday,
        sunday: sunday ?? groupSchedule?.AllowSunday,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<ExpansibleGroupScheduleViewModel?>(
        stream: menuPresenter.expansibleGroupScheduleStream,
        builder: (context, groupSnapshot) {
          return StreamBuilder<ProductScheduleViewModel?>(
              stream: menuPresenter.productScheduleStream,
              builder: (context, productSnapshot) {
                ExpansibleGroupScheduleViewModel? groupSchedule =
                    groupSnapshot.data;
                ProductScheduleViewModel? productSchedule =
                    productSnapshot.data;

                bool allowMonday = widget.isUpdatingProduct
                    ? productSchedule?.AllowMonday != false
                    : groupSchedule?.AllowMonday != false;
                bool allowTuesday = widget.isUpdatingProduct
                    ? productSchedule?.AllowTuesday != false
                    : groupSchedule?.AllowTuesday != false;
                bool allowWednesday = widget.isUpdatingProduct
                    ? productSchedule?.AllowWednesday != false
                    : groupSchedule?.AllowWednesday != false;
                bool allowThursday = widget.isUpdatingProduct
                    ? productSchedule?.AllowThursday != false
                    : groupSchedule?.AllowThursday != false;
                bool allowFriday = widget.isUpdatingProduct
                    ? productSchedule?.AllowFriday != false
                    : groupSchedule?.AllowFriday != false;
                bool allowSaturday = widget.isUpdatingProduct
                    ? productSchedule?.AllowSaturday != false
                    : groupSchedule?.AllowSaturday != false;
                bool allowSunday = widget.isUpdatingProduct
                    ? productSchedule?.AllowSunday != false
                    : groupSchedule?.AllowSunday != false;

                return Column(
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isUpdatingProduct
                                ? widget.product?.Name ?? ""
                                : widget.expansibleGroup?.Name ?? "",
                            style: TextStyle(
                              fontSize: getStringSize(context) * 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            widget.isUpdatingProduct
                                ? "(${R.string.product})"
                                : "(${R.string.expansibleGroup})",
                            style: TextStyle(
                              fontSize: getStringSize(context),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowMonday,
                      dayName: R.string.monday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          monday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowTuesday,
                      dayName: R.string.tuesday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          tuesday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowWednesday,
                      dayName: R.string.wednesday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          wednesday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowThursday,
                      dayName: R.string.thursday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          thursday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowFriday,
                      dayName: R.string.friday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          friday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowSaturday,
                      dayName: R.string.saturday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          saturday: value,
                        );
                      },
                    ),
                    personalizedCheckBox(
                      dayEnabled: allowSunday,
                      dayName: R.string.sunday,
                      onChanged: (value) {
                        updateSchedule(
                          menuPresenter: menuPresenter,
                          groupSchedule: groupSchedule,
                          productSchedule: productSchedule,
                          sunday: value,
                        );
                      },
                    ),
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
                              onPressed: (widget.isUpdatingProduct &&
                                          productSchedule == null) ||
                                      (groupSchedule == null &&
                                          !widget.isUpdatingProduct)
                                  ? null
                                  : () async {
                                      await onPressed(
                                        menuPresenter: menuPresenter,
                                        expansibleGroupFromProductPresenter:
                                            expansibleGroupFromProductPresenter,
                                        homePresenter: homePresenter,
                                        configurationsPresenter:
                                            configurationsPresenter,
                                        callSetState: widget.callSetState,
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
        });
  }

  Future<void> onPressed({
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required HomePresenter homePresenter,
    required ConfigurationsPresenter configurationsPresenter,
    required void Function() callSetState,
  }) async {
    bool updated = false;
    notificationDialog(
      context: context,
      titleMessage: R.string.confirmSchedule,
      content: null,
      onPress: () async {
        if (widget.isUpdatingProduct && widget.product != null) {
          updated = await menuPresenter.insertUpdateProductSchedule(
            internalCodeOnErp: widget.product!.InternalCodeOnERP!.toInt(),
            homePresenter: homePresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );
        } else if (!widget.isUpdatingProduct &&
            widget.expansibleGroup != null) {
          updated = await menuPresenter.insertUpdateExpansibleGroupSchedule(
            expansibleGroupId:
                widget.expansibleGroup!.ExpansibleGroupId.toInt(),
            homePresenter: homePresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );
        }

        if (updated) {
          Navigator.of(context).pop();

          notificationDialog(
              context: context,
              titleMessage: R.string.msgSuccessToUpdateSchedule,
              content:
                  Center(child: Text(R.string.msgWantUpdateMenuInAllDevices)),
              onPress: () async {
                await configurationsPresenter.loadMenuAgain();
              });
          callSetState();
        }
      },
    );
  }

  Widget personalizedCheckBox({
    required bool? dayEnabled,
    required String dayName,
    required void Function(bool?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        title: Text(dayName),
        value: dayEnabled == true,
        fillColor:
            dayEnabled == true ? WidgetStatePropertyAll(Colors.green) : null,
        tileColor:
            dayEnabled == true ? Colors.green.withAlpha(120) : Colors.red[100],
        onChanged: onChanged,
      ),
    );
  }
}
