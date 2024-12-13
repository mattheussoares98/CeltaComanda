// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class EnableOrDisableDays extends StatefulWidget {
  final ProductsViewModel? product;
  final ExpansibleGroupsViewModel expansibleGroup;
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
        if (widget.isUpdatingProduct && widget.product != null) {
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

                updateAllowDays(groupSchedule, productSchedule);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isUpdatingProduct
                                    ? widget.product?.Name ?? ""
                                    : widget.expansibleGroup.Name,
                                style: TextStyle(
                                  fontSize: StringSize.size * 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                widget.isUpdatingProduct
                                    ? widget.product?.childsComposition !=
                                                null &&
                                            widget.product!.childsComposition!
                                                .isNotEmpty
                                        ? " (${R.string.combox})"
                                        : "(${R.string.product})"
                                    : "(${R.string.expansibleGroup})",
                                style: TextStyle(
                                  fontSize: StringSize.size,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PersonalizedsCheckBox(
                        isUpdatingProduct: widget.isUpdatingProduct,
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
                        isUpdatingProduct: widget.isUpdatingProduct,
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
  ) {
    allowMonday = widget.isUpdatingProduct
        ? productSchedule?.AllowMonday != false
        : groupSchedule?.AllowMonday != false;
    allowTuesday = widget.isUpdatingProduct
        ? productSchedule?.AllowTuesday != false
        : groupSchedule?.AllowTuesday != false;
    allowWednesday = widget.isUpdatingProduct
        ? productSchedule?.AllowWednesday != false
        : groupSchedule?.AllowWednesday != false;
    allowThursday = widget.isUpdatingProduct
        ? productSchedule?.AllowThursday != false
        : groupSchedule?.AllowThursday != false;
    allowFriday = widget.isUpdatingProduct
        ? productSchedule?.AllowFriday != false
        : groupSchedule?.AllowFriday != false;
    allowSaturday = widget.isUpdatingProduct
        ? productSchedule?.AllowSaturday != false
        : groupSchedule?.AllowSaturday != false;
    allowSunday = widget.isUpdatingProduct
        ? productSchedule?.AllowSunday != false
        : groupSchedule?.AllowSunday != false;
  }
}
