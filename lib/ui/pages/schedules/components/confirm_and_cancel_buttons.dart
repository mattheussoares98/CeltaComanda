// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmAndCancelButtons extends StatelessWidget {
  final ScheduleType scheduleType;
  final ExpansibleGroupScheduleViewModel? groupSchedule;
  final ProductScheduleViewModel? productSchedule;
  final ExpansibleGroupsViewModel expansibleGroup;
  final ProductCompositionViewModel? child;
  final void Function() callSetState;
  final ProductsViewModel? product;
  const ConfirmAndCancelButtons({
    required this.scheduleType,
    required this.groupSchedule,
    required this.productSchedule,
    required this.expansibleGroup,
    required this.child,
    required this.callSetState,
    required this.product,
    super.key,
  });

  bool canConfirm() {
    if (scheduleType == ScheduleType.product && productSchedule == null) {
      return false;
    } else if (scheduleType == ScheduleType.expansibleGroup &&
        groupSchedule == null) {
      return false;
    } else if (scheduleType == ScheduleType.child && productSchedule == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
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
              onPressed: canConfirm()
                  ? () async {
                      await onPressed(
                        expansibleGroupFromProductPresenter:
                            expansibleGroupFromProductPresenter,
                        homePresenter: homePresenter,
                        child: child,
                        product: product,
                        scheduleType: scheduleType,
                        context: context,
                        expansibleGroupId:
                            expansibleGroup.ExpansibleGroupId.toInt(),
                        menuPresenter: menuPresenter,
                        configurationsPresenter: configurationsPresenter,
                        callSetState: () {
                          callSetState();
                        },
                      );
                    }
                  : null,
              child: Text(R.string.confirm),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onPressed({
    required MenuPresenter menuPresenter,
    required ConfigurationsPresenter configurationsPresenter,
    required HomePresenter homePresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required void Function() callSetState,
    required int expansibleGroupId,
    required BuildContext context,
    required ProductsViewModel? product,
    required ScheduleType scheduleType,
    required ProductCompositionViewModel? child,
  }) async {
    bool updated = false;
    notificationDialog(
      context: context,
      titleMessage: R.string.confirmSchedule,
      content: null,
      onPress: () async {
        if (scheduleType == ScheduleType.product && product != null) {
          updated = await menuPresenter.insertUpdateProductSchedule(
            internalCodeOnErp: product.InternalCodeOnERP!.toInt(),
            expansibleGroupId: expansibleGroupId,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
            homePresenter: homePresenter,
          );
        } else if (scheduleType == ScheduleType.expansibleGroup) {
          updated = await menuPresenter
              .insertUpdateExpansibleGroupSchedule(expansibleGroupId);
        } else if (scheduleType == ScheduleType.child && child != null) {
          updated = await menuPresenter.insertUpdateProductSchedule(
            internalCodeOnErp: child.InternalCodeOnERPCodeChild!.toInt(),
            expansibleGroupId: expansibleGroupId,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
            homePresenter: homePresenter,
          );
        }

        if (updated) {
          Navigator.of(context).pop();

          callSetState();
          // await notificationDialog(
          //     context: context,
          //     titleMessage: R.string.msgSuccessToUpdateSchedule,
          //     content: Text(
          //       R.string.msgWantUpdateMenuInAllDevices,
          //       textAlign: TextAlign.center,
          //     ),
          //     onPress: () async {
          //       await configurationsPresenter.loadMenuAgain(
          //           EnterpriseBuilder.entity?.enterpriseName ?? "");
          //     });
        }
      },
    );
  }
}
