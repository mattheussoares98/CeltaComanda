import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

class FixedNumberCommandSwitch extends StatelessWidget {
  final bool useFixedCommand;
  const FixedNumberCommandSwitch({
    required this.useFixedCommand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey tooltipKey = GlobalKey();
    EnterpriseValidationPresenter enterpriseValidationPresenter =
        Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: useFixedCommand,
          onChanged: (_) {
            enterpriseValidationPresenter.updateUseFixedCommandNumber();
          },
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            "Usar sempre a mesma mesa",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: hasMinWidth(context) ? 23 : 15),
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
            message:
                'Essa opção deve ser usada somente quando estiver utilizando um tablet fixo por mesa',
            child: Icon(
              Icons.info,
              size: hasMinWidth(context) ? 40 : 30,
            ),
          ),
        )
      ],
    );
  }
}
