import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class ReserveTable extends StatelessWidget {
  const ReserveTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onLongPress: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: Colors.black45,
          body: Center(
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    R.string.table.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    R.string.reserved,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
