import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class ConfigurationsPage extends StatelessWidget {
  const ConfigurationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.configurations),
      ),
      body: Center(child: Text(R.string.configurations)),
    );
  }
}
