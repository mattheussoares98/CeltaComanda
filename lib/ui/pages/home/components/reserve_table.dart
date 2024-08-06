import 'package:flutter/material.dart';

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
        child: const Scaffold(
          backgroundColor: Colors.black12,
          body: Center(
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    "MESA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "RESERVADA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
