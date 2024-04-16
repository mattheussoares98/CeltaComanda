import 'package:flutter/material.dart';

class ReturnIcon extends StatelessWidget {
  const ReturnIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Align(
        alignment: AlignmentDirectional(0.85, -0.4),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
