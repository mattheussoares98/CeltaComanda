import 'package:flutter/material.dart';

class SaleMovementPage extends StatelessWidget {
  const SaleMovementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              // ignore: avoid_print
              print('loadSales');
            },
            child: const Text('Load Sales'),
          ),
        ],
      ),
    );
  }
}
