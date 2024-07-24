import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class AddMoreCartItensButton extends StatelessWidget {
  const AddMoreCartItensButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColorLight,
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
