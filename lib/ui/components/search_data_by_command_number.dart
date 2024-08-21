import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/helpers/sizes/sizes.dart';
import '../pages/pages.dart';

class SearchDataByCommandNumber extends StatelessWidget {
  final HomePresenter homePresenter;
  final Future Function() loadCommandData;
  final String emptyMessage;
  const SearchDataByCommandNumber({
    required this.homePresenter,
    required this.loadCommandData,
    required this.emptyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final usableScreenHeight = screenHeight - appBarHeight - statusBarHeight;

    return SizedBox(
      height: usableScreenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (homePresenter.commandNumber != null)
            Text(
              "Comanda ${homePresenter.commandNumber?.replaceAll(RegExp(r'0'), '')}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: hasMinWidth(context) ? 40 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: hasMinWidth(context) ? 30 : 23,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              await loadCommandData();
            },
            icon: Icon(
              Icons.search,
              size: hasMinWidth(context) ? 40 : 25,
              color: Theme.of(context).primaryColorDark,
            ),
            label: Text(
              "Consultar dados da comanda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 30 : 23,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
