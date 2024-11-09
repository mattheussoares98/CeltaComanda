import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class GoToConfigurationsPageButton extends StatelessWidget {
  const GoToConfigurationsPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await homePresenter.goToConfigurationsPage();
      },
      child: Text(R.string.configurations),
    );
  }
}
