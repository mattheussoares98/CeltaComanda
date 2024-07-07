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
        Image.asset(
          "lib/ui/assets/images/logo_eat_asia.png",
          height: AppBar().preferredSize.height - 20,
          width: AppBar().preferredSize.height - 20,
        ),
        Image.asset(
          "lib/ui/assets/images/hello_kitty.jpeg",
          height: AppBar().preferredSize.height,
          width: AppBar().preferredSize.height,
        ),
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
