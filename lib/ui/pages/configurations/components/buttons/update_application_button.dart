import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UpdateApplicationButton extends StatelessWidget {
  const UpdateApplicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.only(bottom: 8),
        child: Center(
          child: Text(
            R.string.updateApplication,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
