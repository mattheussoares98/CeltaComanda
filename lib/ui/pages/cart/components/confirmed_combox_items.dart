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
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
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
        ),
      ),
    );
  }
}
