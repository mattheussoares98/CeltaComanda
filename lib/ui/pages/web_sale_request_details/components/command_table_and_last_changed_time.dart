import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';

class CommandTableAndLastChangedTime extends StatelessWidget {
  final PrintedEntity saleRequest;
  final DateTime mostRecentRequestFromCurrentSale;
  const CommandTableAndLastChangedTime(
      {super.key,
      required this.saleRequest,
      required this.mostRecentRequestFromCurrentSale});

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
                  text: "${R.string.command} ${saleRequest.PersonalizedCode}",
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
                    mostRecentRequestFromCurrentSale.day != DateTime.now().day
                        ? "dd/MM HH:mm:ss"
                        : "HH:mm:ss")
                .format(mostRecentRequestFromCurrentSale),
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium,
          ),
        )
      ],
    );
  }
}
