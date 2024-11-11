import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class ConfigurationsPage extends StatelessWidget {
  final ConfigurationsPresenter configurationsPresenter;
  const ConfigurationsPage({
    required this.configurationsPresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    final buttons = [
      GoToCancelProductsPageButton(),
      LogoutButton(),
      if (!homePresenter.isGeneratingVersionToRede &&
          !homePresenter.isGeneratingVersionToGetNet)
        const ReserveTableButton(),
      ElevatedButton(
        onPressed: () async {
          await _openOrBlock(
            liberate: true,
            configurationsPresenter: configurationsPresenter,
            context: context,
            commandNumber: homePresenter.commandNumber!.toInt(),
          );
        },
        child: FittedBox(child: Text(R.string.liberateCommand)),
      ),
      ElevatedButton(
        onPressed: () async {
          await _openOrBlock(
            configurationsPresenter: configurationsPresenter,
            liberate: false,
            context: context,
            commandNumber: homePresenter.commandNumber!.toInt(),
          );
        },
        child: FittedBox(child: Text(R.string.blockCommand)),
      ),
    ];

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        printedProductsPresenter.loadPrinted(homePresenter.commandNumber!);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.configurations),
        ),
        body: ListenableProvider(
          create: (_) => configurationsPresenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: hasMinWidth(context) ? 3 : 2,
                childAspectRatio: hasMinWidth(context) ? 5 : 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return buttons[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openOrBlock({
  required ConfigurationsPresenter configurationsPresenter,
  required bool liberate,
  required BuildContext context,
  required int commandNumber,
}) async {
  final updated = await configurationsPresenter.openOrBlockadeCommand(
    commandNumber: commandNumber,
    isOpen: liberate,
  );

  if (updated) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
      snackBarMessage(
        context,
        liberate ? R.string.msgReleasesCommand : R.string.msgBlockedCommand,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      );
    });
  }
}
