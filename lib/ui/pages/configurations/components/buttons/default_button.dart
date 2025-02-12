import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class DefaultButton extends StatelessWidget {
  final String name;
  final Function() function;
  final bool isNew;

  const DefaultButton({
    super.key,
    required this.name,
    required this.function,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
  }
}
