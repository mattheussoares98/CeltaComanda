import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleAppbar extends StatelessWidget {
  const TitleAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: true);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (homePresenter.commandNumber != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        iconPadding: const EdgeInsets.all(8),
                        titlePadding: const EdgeInsets.all(8),
                        buttonPadding: const EdgeInsets.all(8),
                        actionsPadding: const EdgeInsets.all(8),
                        insetPadding: const EdgeInsets.all(20),
                        contentPadding: const EdgeInsets.all(10),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              R.string.close.toUpperCase(),
                              style: TextStyle(
                                fontSize: getStringSize(context),
                              ),
                            ),
                          ),
                        ],
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const TableConfigurationsPage(),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "${R.string.table} ${homePresenter.commandNumber?.toInt()}",
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
        IconButton(
          onPressed: () async {
            await homePresenter.loadCommandData(
              menuPresenter: menuPresenter,
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              commentsPresenter: commentsPresenter,
              homePresenter: homePresenter,
            );
          },
          icon: Icon(
            Icons.refresh_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: "Atualizar menu",
        ),
      ],
    );
  }
}
