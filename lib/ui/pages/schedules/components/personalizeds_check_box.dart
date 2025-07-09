import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class PersonalizedsCheckBox extends StatelessWidget {
  final ScheduleType scheduleType;
  final ProductsViewModel? product;
  final ExpansibleGroupsViewModel expansibleGroup;
  final ProductCompositionViewModel? child;
  final bool allowMonday;
  final bool allowTuesday;
  final bool allowWednesday;
  final bool allowThursday;
  final bool allowFriday;
  final bool allowSaturday;
  final bool allowSunday;
  final ExpansibleGroupScheduleViewModel? groupSchedule;
  final ProductScheduleViewModel? productSchedule;
  const PersonalizedsCheckBox({
    required this.scheduleType,
    required this.product,
    required this.expansibleGroup,
    required this.child,
    required this.allowMonday,
    required this.allowTuesday,
    required this.allowWednesday,
    required this.allowThursday,
    required this.allowFriday,
    required this.allowSaturday,
    required this.allowSunday,
    required this.groupSchedule,
    required this.productSchedule,
    super.key,
  });

  void updateScheduleStream({
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
    if (scheduleType == ScheduleType.product && product != null) {
      menuPresenter.updateProductScheduleStream(
        internalCodeOnErp: product!.InternalCodeOnERP!.toInt(),
        monday: monday ?? productSchedule?.AllowMonday,
        tuesday: tuesday ?? productSchedule?.AllowTuesday,
        wednesday: wednesday ?? productSchedule?.AllowWednesday,
        thursday: thursday ?? productSchedule?.AllowThursday,
        friday: friday ?? productSchedule?.AllowFriday,
        saturday: saturday ?? productSchedule?.AllowSaturday,
        sunday: sunday ?? productSchedule?.AllowSunday,
      );
    } else if (scheduleType == ScheduleType.expansibleGroup) {
      menuPresenter.updateExpansibleGroupScheduleStream(
        expansibleGroupId: expansibleGroup.ExpansibleGroupId.toInt(),
        monday: monday ?? groupSchedule?.AllowMonday,
        tuesday: tuesday ?? groupSchedule?.AllowTuesday,
        wednesday: wednesday ?? groupSchedule?.AllowWednesday,
        thursday: thursday ?? groupSchedule?.AllowThursday,
        friday: friday ?? groupSchedule?.AllowFriday,
        saturday: saturday ?? groupSchedule?.AllowSaturday,
        sunday: sunday ?? groupSchedule?.AllowSunday,
      );
    } else {
      menuPresenter.updateProductScheduleStream(
        internalCodeOnErp: child!.InternalCodeOnERPCodeChild!.toInt(),
        monday: monday ?? productSchedule?.AllowMonday,
        tuesday: tuesday ?? productSchedule?.AllowTuesday,
        wednesday: wednesday ?? productSchedule?.AllowWednesday,
        thursday: thursday ?? productSchedule?.AllowThursday,
        friday: friday ?? productSchedule?.AllowFriday,
        saturday: saturday ?? productSchedule?.AllowSaturday,
        sunday: sunday ?? productSchedule?.AllowSunday,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        personalizedCheckBox(
          dayEnabled: allowMonday,
          dayName: R.string.monday,
          context: context,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              monday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowTuesday,
          dayName: R.string.tuesday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              tuesday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowWednesday,
          dayName: R.string.wednesday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              wednesday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowThursday,
          dayName: R.string.thursday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              thursday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowFriday,
          dayName: R.string.friday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              friday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowSaturday,
          dayName: R.string.saturday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              saturday: value,
            );
          },
        ),
        personalizedCheckBox(
          context: context,
          dayEnabled: allowSunday,
          dayName: R.string.sunday,
          onChanged: (value) {
            updateScheduleStream(
              menuPresenter: menuPresenter,
              groupSchedule: groupSchedule,
              productSchedule: productSchedule,
              sunday: value,
            );
          },
        )
      ],
    );
  }

  Widget personalizedCheckBox({
    required bool? dayEnabled,
    required String dayName,
    required void Function(bool?)? onChanged,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        title: Text(
          dayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        value: dayEnabled == true,
        fillColor:
            dayEnabled == true ? const WidgetStatePropertyAll(Colors.green) : null,
        tileColor:
            dayEnabled == true ? Colors.green.withAlpha(120) : Colors.red[100],
        onChanged: onChanged,
      ),
    );
  }
}
