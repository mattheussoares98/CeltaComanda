import 'package:flutter/material.dart';

import '../../../../../helpers/helpers.dart';

class UpdateConfigurationsButton extends StatelessWidget {
  final Future<void> Function() updateCommand;
  const UpdateConfigurationsButton({
    required this.updateCommand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await updateCommand();
      },
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
          child: Text(
            R.string.updateConfigurations,
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ),
    );
  }
}
