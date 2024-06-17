import 'package:flutter/material.dart';

import '../../pages.dart';

class ConfirmedProductItems extends StatelessWidget {
  final List<ConfirmedComboxViewModel> confirmedsCombox;
  const ConfirmedProductItems({
    required this.confirmedsCombox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: confirmedsCombox.length,
      itemBuilder: (context, index) {
        final combox = confirmedsCombox[index];

        return ConfirmedComboxItem(confirmedCombox: combox);
      },
    );
  }
}
