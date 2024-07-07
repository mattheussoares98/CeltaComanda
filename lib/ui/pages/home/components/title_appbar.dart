import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import '../../../helpers/helpers.dart';

class TitleAppbar extends StatelessWidget {
  final void Function() loadMenuAgain;
  final bool showLoadMenuAgain;
  const TitleAppbar({
    required this.loadMenuAgain,
    required this.showLoadMenuAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
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
