import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class TitleAppbar extends StatelessWidget {
  const TitleAppbar({
    super.key,
  });

  void doOnPress(BuildContext context) {
    notificationDialog(
      context: context,
      titleMessage: R.string.accessConfigurations,
      content: const ConfigurationsDialogPage(onlyRemoveServiceChargeOnSuccess: false),
      showCancelAndConfirmMessage: false,
      onPress: () async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (homePresenter.commandEntity?.commandNumber != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  doOnPress(context);
                },
                onLongPress: () {
                  doOnPress(context);
                },
                child: Text(
                  "${R.string.table} ${homePresenter.commandEntity!.commandNumber?.toInt()}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenSize.hasMinWidth ? 23 : 15,
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
