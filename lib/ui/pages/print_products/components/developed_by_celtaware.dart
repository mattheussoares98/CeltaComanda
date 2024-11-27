import 'package:flutter/material.dart';

class DevelopedByCeltaware extends StatelessWidget {
  const DevelopedByCeltaware({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Divider(thickness: 0.2),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: Text(
              "" + "Desenvolvido por Celtaware",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
