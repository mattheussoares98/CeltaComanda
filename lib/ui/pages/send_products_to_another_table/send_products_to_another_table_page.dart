import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class SendProductsToAnotherTablePage extends StatelessWidget {
  const SendProductsToAnotherTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(R.string.send)),
    );
  }
}
