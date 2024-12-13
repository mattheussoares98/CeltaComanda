// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmAndCancelButtons extends StatelessWidget {
  final bool isUpdatingProduct;
  final ExpansibleGroupScheduleViewModel? groupSchedule;
  final ProductScheduleViewModel? productSchedule;
  final ExpansibleGroupsViewModel expansibleGroup;
  final void Function() callSetState;
  const ConfirmAndCancelButtons({
    required this.isUpdatingProduct,
    required this.groupSchedule,
    required this.productSchedule,
    required this.expansibleGroup,
    required this.callSetState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
              onPressed: (isUpdatingProduct && productSchedule == null) ||
                      (groupSchedule == null && !isUpdatingProduct)
                  ? null
                  : () async {
                      await onPressed(
                        context: context,
                        expansibleGroupId:
                            expansibleGroup.ExpansibleGroupId.toInt(),
                        menuPresenter: menuPresenter,
                        configurationsPresenter: configurationsPresenter,
                        callSetState: () {
                          callSetState();
                        },
                      );
                    },
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
    required void Function() callSetState,
    required int expansibleGroupId,
    required BuildContext context,
    final ProductsViewModel? product,
  }) async {
    bool updated = false;
    notificationDialog(
      context: context,
      titleMessage: R.string.confirmSchedule,
      content: null,
      onPress: () async {
        if (isUpdatingProduct && product != null) {
          updated = await menuPresenter.insertUpdateProductSchedule(
            internalCodeOnErp: product.InternalCodeOnERP!.toInt(),
            expansibleGroupId: expansibleGroupId,
          );
        } else if (!isUpdatingProduct) {
          updated = await menuPresenter
              .insertUpdateExpansibleGroupSchedule(expansibleGroupId);
        }

        if (updated) {
          Navigator.of(context).pop();

          callSetState();
          await notificationDialog(
              context: context,
              titleMessage: R.string.msgSuccessToUpdateSchedule,
              content: Text(
                R.string.msgWantUpdateMenuInAllDevices,
                textAlign: TextAlign.center,
              ),
              onPress: () async {
                await configurationsPresenter.loadMenuAgain();
              });
        }
      },
    );
  }
}
