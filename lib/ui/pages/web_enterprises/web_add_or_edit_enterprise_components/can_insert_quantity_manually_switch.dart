import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CanInsertQuantityManuallySwitch extends StatelessWidget {
  final bool canInsertQuantityManually;
  final void Function() changeCanInsertQuantityManually;
  const CanInsertQuantityManuallySwitch({
    required this.canInsertQuantityManually,
    required this.changeCanInsertQuantityManually,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          changeCanInsertQuantityManually();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(R.string.canInsertQuantityManually)),
              Switch(
                value: canInsertQuantityManually,
                onChanged: (_) {
                  changeCanInsertQuantityManually();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
