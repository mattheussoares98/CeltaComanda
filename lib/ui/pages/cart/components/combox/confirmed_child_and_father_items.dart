import 'package:flutter/material.dart';

import '../../../pages.dart';

class ConfirmedChildAndFatherItems extends StatelessWidget {
  final List<ConfirmedComboxViewModel> confirmedsCombox;
  const ConfirmedChildAndFatherItems({
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
        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Color(0x33000000),
                offset: Offset(-3, -1),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageFathernameAndPrice(
                confirmedCombox: combox,
                confirmedComboxIndex: index,
              ),
              ConfirmedChildComboxItem(
                confirmedCombox: combox,
                indexOfConfirmedCombox: index,
              ),
            ],
          ),
        );
      },
    );
  }
}
