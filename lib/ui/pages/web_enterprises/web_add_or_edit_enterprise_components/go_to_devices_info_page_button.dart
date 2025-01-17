import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GoToDevicesInfoPageButton extends StatelessWidget {
  const GoToDevicesInfoPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () {
          webEnterprisesPresenter.goToDevicesInfoPage();
        },
        child: Text(R.string.devicesInformations),
      ),
    );
  }
}
