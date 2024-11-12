import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class GoToConfigurationsPageButton extends StatelessWidget {
  final Future<void> Function() goToConfigurationsPage;

  const GoToConfigurationsPageButton({
    required this.goToConfigurationsPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: goToConfigurationsPage,
      child: Text(R.string.confirm),
    );
  }
}
