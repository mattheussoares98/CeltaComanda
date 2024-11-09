import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final buttons = [
      GoToCancelProductsPageButton(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.configurations),
      ),
      body: ListenableProvider(
        create: (_) => configurationsPresenter,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: hasMinWidth(context) ? 3 : 2,
            childAspectRatio: hasMinWidth(context) ? 5 : 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return buttons[index];
          },
        ),
      ),
    );
  }
}
