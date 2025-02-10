import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class UseProductReducedNameSwitch extends StatelessWidget {
  final bool useReducedName;
  final void Function() changeUseProductReducedName;
  const UseProductReducedNameSwitch({
    required this.useReducedName,
    required this.changeUseProductReducedName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          changeUseProductReducedName();
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
              Expanded(child: Text(R.string.useProductReducedName)),
              Switch(
                value: useReducedName,
                onChanged: (_) {
                  changeUseProductReducedName();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
