import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';

class CommandTableAndLastChangedTime extends StatelessWidget {
  final DeliveryControlEntity deliveryControl;

  const CommandTableAndLastChangedTime({
    super.key,
    required this.deliveryControl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateHourOfCreation =
        deliveryControl.Products!.first.DateHourOfCreation;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium,
              children: [
                TextSpan(
                  text: deliveryControl.OriginType ==
                          DeliveryOriginType.saleRequest
                      ? "${R.string.command} ${deliveryControl.PersonalizedCode}"
                      : "${R.string.sale} ${deliveryControl.CouponFiscalNumber}",
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Text(
            DateFormat(dateHourOfCreation.day != DateTime.now().day
                    ? "dd/MM HH:mm:ss"
                    : "HH:mm:ss")
                .format(dateHourOfCreation),
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium,
          ),
        )
      ],
    );
  }
}
