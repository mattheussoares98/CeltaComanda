import 'package:flutter/material.dart';

import '../../pages.dart';

class ConfirmedComboxItems extends StatelessWidget {
  final List<ConfirmedComboxViewModel> confirmedsCombox;
  const ConfirmedComboxItems({
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

        return ConfirmedComboxItem(
          confirmedCombox: combox,
          index: index,
        );
      },
    );
  }
}
