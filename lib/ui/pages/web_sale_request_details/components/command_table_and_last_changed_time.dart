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
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium,
              children: [
                TextSpan(
                  text:
                      "${deliveryControl.CouponFiscalNumber == null ? R.string.command : R.string.sale} ${deliveryControl.CouponFiscalNumber ?? deliveryControl.PersonalizedCode}",
                  style: theme.textTheme.titleLarge,
                ),
                // if (saleRequest.PlaceId != null &&
                //     saleRequest.PlaceId!.isNotEmpty)
                //   TextSpan(
                //     text: ' - Mesa (${saleRequest.PlaceId!})',
                //     style: theme.textTheme.titleLarge,
                //   ),
                //TODO check if has this property
              ],
            ),
          ),
        ),
        Expanded(
          child: Text(
            DateFormat(
                    deliveryControl.DateHourOfCreation.day != DateTime.now().day
                        ? "dd/MM HH:mm:ss"
                        : "HH:mm:ss")
                .format(deliveryControl.DateHourOfCreation),
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium,
          ),
        )
      ],
    );
  }
}
