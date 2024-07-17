import 'package:flutter/material.dart';

class PreLoadImagesPage extends StatelessWidget {
  const PreLoadImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Text("");
      },
    );
  }
}
