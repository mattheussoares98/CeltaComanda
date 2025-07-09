import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class DevelopedByCeltaware extends StatelessWidget {
  const DevelopedByCeltaware({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Divider(
          thickness: 0.2,
          height: 25,
        ),
        Center(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: Text(
              R.string.developedByCeltaware,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: StringSize.size * 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
