import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class OpenSchedulesPageButton extends StatelessWidget {
  const OpenSchedulesPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await configurationsPresenter.goToSchedulesPage();
      },
      child: Text(
        R.string.productsSchedules,
      ),
    );
  }
}
