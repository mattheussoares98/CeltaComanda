import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FixedNumberCommandSwitch extends StatelessWidget {
  final bool isFixedCommandNumber;
  final void Function() updateIsFixedCommandNumber;
  const FixedNumberCommandSwitch({
    required this.isFixedCommandNumber,
    required this.updateIsFixedCommandNumber,
    super.key,
  });

  static final GlobalKey tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isFixedCommandNumber,
          onChanged: (_) {
            updateIsFixedCommandNumber();
          },
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            R.string.alwaysUseSameTable,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: ScreenSize.hasMinWidth ? 23 : 15),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            final dynamic tooltip = tooltipKey.currentState;
            tooltip.ensureTooltipVisible();
          },
          child: Tooltip(
            key: tooltipKey,
            message: R.string.msgUseOnlyWhenIsFixedTableNumber,
            child: Icon(
              Icons.info,
              size: ScreenSize.hasMinWidth ? 40 : 30,
            ),
          ),
        )
      ],
    );
  }
}
