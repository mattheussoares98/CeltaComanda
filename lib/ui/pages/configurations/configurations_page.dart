import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

class ConfigurationsPage extends StatelessWidget {
  final ConfigurationsPresenter configurationsPresenter;
  const ConfigurationsPage({
    required this.configurationsPresenter,
    super.key,
  });

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
