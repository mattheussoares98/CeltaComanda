import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PrintDate extends StatelessWidget {
  const PrintDate({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    final atualDate = DateTime.now();
    return Column(
      children: [
        if (homePresenter.commandEntity?.pdv?.PdvNumber != null)
          Text(
            "${R.string.pdv.toUpperCase()} ${homePresenter.commandEntity?.pdv?.PdvNumber?.toInt() ?? 0}",
            style: textStyle(context),
          ),
        Text(
          "${atualDate.day.toString().padLeft(2, "0")}/${atualDate.month.toString().padLeft(2, "0")}/${atualDate.year} ${atualDate.hour}:${atualDate.minute}",
          style: textStyle(context),
        ),
      ],
    );
  }
}
