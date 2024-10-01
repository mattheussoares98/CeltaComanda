import 'package:flutter/material.dart';

import '../../pages.dart';

class GetCustomer extends StatelessWidget {
  final CovenantPresenter covenantPresenter;
  const GetCustomer({
    required this.covenantPresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await covenantPresenter.getCustomer("mattheus");
      },
      child: const Text("Get customer"),
    );
  }
}
