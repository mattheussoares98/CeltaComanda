import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

Widget defaultButton({
  required BuildContext context,
  required String name,
  required Function() function,
  bool isNew = false,
}) =>
    LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.minHeight,
            child: ElevatedButton(
              onPressed: function,
              child: Text(
                name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ),
          ),
          if (isNew)
          Positioned(
            left: 5,
            top: 0,
            child: FittedBox(
              child: Text(
                R.string.neww,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
