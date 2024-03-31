import 'dart:math';

import 'package:flutter/material.dart';

class Groups extends StatelessWidget {
  const Groups({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final random = Random();
        final color = Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1,
        );

        List<String> texts = [
          'Texto 1',
          'Texto 2',
          'Texto 3',
          'Texto 4',
          'Texto 5',
          'Texto 6',
          'Texto 7',
          'Texto 8',
          'Texto 9',
          'Texto 10',
          'Texto 11',
          'Texto 12',
        ];

        return Container(
          margin: const EdgeInsets.all(8),
          height: 100,
          color: color,
          child: Center(
            child: Text(
              texts[index % texts.length],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
