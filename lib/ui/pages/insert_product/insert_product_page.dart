import 'package:flutter/material.dart';

class InsertProductPage extends StatelessWidget {
  const InsertProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 400,
                )),
          ),
        ),
      ),
      body: const Center(
        child: Text("Insert products page"),
      ),
    );
  }
}
