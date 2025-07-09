import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../pages/pages.dart';

class PdvNumber extends StatelessWidget {
  const PdvNumber({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    if (homePresenter.commandEntity?.pdv?.PdvNumber != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          "${R.string.pdv.toUpperCase()} ${homePresenter.commandEntity!.pdv!.PdvNumber!.toInt()}",
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox();
  }
}
