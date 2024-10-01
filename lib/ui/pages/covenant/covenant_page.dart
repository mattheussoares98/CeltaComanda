import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

class CovenantPage extends StatefulWidget {
  final CovenantPresenter covenantPresenter;
  const CovenantPage({
    required this.covenantPresenter,
    super.key,
  });

  @override
  State<CovenantPage> createState() => _CovenantPageState();
}

class _CovenantPageState extends State<CovenantPage> {
  final textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.covenant)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetCustomer(
              covenantPresenter: widget.covenantPresenter,
              textController: textController,
            ),
          ],
        ),
      ),
    );
  }
}
