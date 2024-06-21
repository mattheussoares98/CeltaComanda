import 'package:flutter/material.dart';

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
              "Comanda ${homePresenter.commandNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: () async {
              await loadCommandData();
            },
            icon: const Icon(Icons.search),
            label: const Text(
              "Consultar dados da comanda",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
