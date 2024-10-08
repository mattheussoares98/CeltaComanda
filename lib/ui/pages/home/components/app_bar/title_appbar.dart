import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class TitleAppbar extends StatelessWidget {
  const TitleAppbar({
    super.key,
  });

  void doOnTapOrLongPress(BuildContext context) {
    PersonalizedDialogPage.open(
      context: context,
      page: const TableConfigurationsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onDoubleTap: () {
                doOnTapOrLongPress(context);
              },
              onLongPress: () {
                doOnTapOrLongPress(context);
              },
              child: Text(
                homePresenter.isFixedCommandNumber
                    ? "${R.string.table} ${homePresenter.commandNumber?.toInt()}"
                    : R.string.configurations,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: hasMinWidth(context) ? 23 : 15,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
