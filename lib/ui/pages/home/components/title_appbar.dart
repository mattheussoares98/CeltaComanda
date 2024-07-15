import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import '../../../helpers/helpers.dart';

class TitleAppbar extends StatelessWidget {
  final void Function() loadMenuAgain;
  final bool showLoadMenuAgain;
  final void Function() openDrawer;
  const TitleAppbar({
    required this.loadMenuAgain,
    required this.showLoadMenuAgain,
    required this.openDrawer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 5,
                        child: AlertDialog(
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          content: ImageWidget(
                            ean: null,
                            plu: "null",
                            isAlcoholic: false,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
          child: SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ImageWidget(
                ean: null,
                plu: "null",
                isAlcoholic: false,
              ),
            ),
          ),
        ),
        if (homePresenter.commandNumber != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  openDrawer();
                },
                child: Text(
                  "Comanda ${homePresenter.commandNumber}",
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
        if (showLoadMenuAgain)
          IconButton(
            onPressed: loadMenuAgain,
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
