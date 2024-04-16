import 'package:flutter/material.dart';

class ExpansibleOptions extends StatelessWidget {
  const ExpansibleOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Color(0xFFE0E3E7),
              offset: Offset(
                0.0,
                1,
              ),
            )
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Color',
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF57636C),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
