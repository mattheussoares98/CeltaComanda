import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class AddMoreCartItensButton extends StatelessWidget {
  final double buttonHeight;
  const AddMoreCartItensButton({
    required this.buttonHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColorLight,
        minimumSize: Size(double.infinity, buttonHeight),
        maximumSize: Size(double.infinity, buttonHeight),
      ),
      onPressed: Navigator.of(context).pop,
      child: FittedBox(
        child: Text(
          "Adicionar mais itens",
          style: TextStyle(
            color: Colors.white,
            fontSize: hasMinWidth(context) ? 23 : 16,
          ),
        ),
      ),
    );
  }
}
