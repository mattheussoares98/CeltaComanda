import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class AddMoreCartItensButton extends StatelessWidget {
  final PageController pageController;
  const AddMoreCartItensButton({
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      onPressed: () {
        pageController.jumpToPage(0);
      },
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
