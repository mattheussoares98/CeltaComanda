// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class EnableOrDisableDays extends StatefulWidget {
  final ProductsViewModel? product;
  final ExpansibleGroupsViewModel expansibleGroup;
  final void Function() callSetState;
  final ScheduleType scheduleType;
  final ProductCompositionViewModel? child;
  const EnableOrDisableDays({
    required this.product,
    required this.expansibleGroup,
    required this.callSetState,
    required this.scheduleType,
    required this.child,
    super.key,
  });

  @override
  State<EnableOrDisableDays> createState() => _EnableOrDisableDaysState();
}

class _EnableOrDisableDaysState extends State<EnableOrDisableDays> {
  bool allowMonday = false;
  bool allowTuesday = false;
  bool allowWednesday = false;
  bool allowThursday = false;
  bool allowFriday = false;
  bool allowSaturday = false;
  bool allowSunday = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        MenuPresenter menuPresenter = Provider.of(context, listen: false);
        if (widget.scheduleType == ScheduleType.product &&
            widget.product != null) {
          menuPresenter.updateProductScheduleStream(
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
        } else if (widget.scheduleType == ScheduleType.child &&
            widget.child != null) {
          menuPresenter.updateProductScheduleStream(
            internalCodeOnErp:
                widget.child!.InternalCodeOnERPCodeChild!.toInt(),
            monday: widget.child!.Schedule?.AllowMonday != false,
            tuesday: widget.child!.Schedule?.AllowTuesday != false,
            wednesday: widget.child!.Schedule?.AllowWednesday != false,
            thursday: widget.child!.Schedule?.AllowThursday != false,
            friday: widget.child!.Schedule?.AllowFriday != false,
            saturday: widget.child!.Schedule?.AllowSaturday != false,
            sunday: widget.child!.Schedule?.AllowSunday != false,
          );
        } else {
          menuPresenter.updateExpansibleGroupScheduleStream(
            expansibleGroupId: widget.expansibleGroup.ExpansibleGroupId.toInt(),
            monday: widget.expansibleGroup.Schedule?.AllowMonday != false,
            tuesday: widget.expansibleGroup.Schedule?.AllowTuesday != false,
            wednesday: widget.expansibleGroup.Schedule?.AllowWednesday != false,
            thursday: widget.expansibleGroup.Schedule?.AllowThursday != false,
            friday: widget.expansibleGroup.Schedule?.AllowFriday != false,
            saturday: widget.expansibleGroup.Schedule?.AllowSaturday != false,
            sunday: widget.expansibleGroup.Schedule?.AllowSunday != false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
                ProductScheduleViewModel? child = productSnapshot.data;

                updateAllowDays(groupSchedule, productSchedule, child);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Column(
                    children: [
                      TitleName(
                        scheduleType: widget.scheduleType,
                        product: widget.product,
                        expansibleGroup: widget.expansibleGroup,
                        child: widget.child,
                      ),
                      PersonalizedsCheckBox(
                        child: widget.child,
                        scheduleType: widget.scheduleType,
                        product: widget.product,
                        expansibleGroup: widget.expansibleGroup,
                        allowMonday: allowMonday,
                        allowTuesday: allowTuesday,
                        allowWednesday: allowWednesday,
                        allowThursday: allowThursday,
                        allowFriday: allowFriday,
                        allowSaturday: allowSaturday,
                        allowSunday: allowSunday,
                        groupSchedule: groupSchedule,
                        productSchedule: productSchedule,
                      ),
                      ConfirmAndCancelButtons(
                        scheduleType: widget.scheduleType,
                        child: widget.child,
                        product: widget.product,
                        expansibleGroup: widget.expansibleGroup,
                        callSetState: widget.callSetState,
                        groupSchedule: groupSchedule,
                        productSchedule: productSchedule,
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void updateAllowDays(
    ExpansibleGroupScheduleViewModel? groupSchedule,
    ProductScheduleViewModel? productSchedule,
    ProductScheduleViewModel? child,
  ) {
    if (widget.scheduleType == ScheduleType.product) {
      allowMonday = productSchedule?.AllowMonday != false;
      allowTuesday = productSchedule?.AllowTuesday != false;
      allowWednesday = productSchedule?.AllowWednesday != false;
      allowThursday = productSchedule?.AllowThursday != false;
      allowFriday = productSchedule?.AllowFriday != false;
      allowSaturday = productSchedule?.AllowSaturday != false;
      allowSunday = productSchedule?.AllowSunday != false;
    } else if (widget.scheduleType == ScheduleType.expansibleGroup) {
      allowMonday = groupSchedule?.AllowMonday != false;
      allowTuesday = groupSchedule?.AllowTuesday != false;
      allowWednesday = groupSchedule?.AllowWednesday != false;
      allowThursday = groupSchedule?.AllowThursday != false;
      allowFriday = groupSchedule?.AllowFriday != false;
      allowSaturday = groupSchedule?.AllowSaturday != false;
      allowSunday = groupSchedule?.AllowSunday != false;
    } else {
      allowMonday = child?.AllowMonday != false;
      allowTuesday = child?.AllowTuesday != false;
      allowWednesday = child?.AllowWednesday != false;
      allowThursday = child?.AllowThursday != false;
      allowFriday = child?.AllowFriday != false;
      allowSaturday = child?.AllowSaturday != false;
      allowSunday = child?.AllowSunday != false;
    }
  }
}
