import 'package:flutter/material.dart';

import '../pages.dart';

class CovenantPage extends StatelessWidget {
  final CovenantPresenter covenantPresenter;
  const CovenantPage({
    required this.covenantPresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Convênio"),
      ),
    );
  }
}
