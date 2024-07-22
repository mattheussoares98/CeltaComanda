import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
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
      itemCount: (confirmedsCombox.length / getItensPerLine(context)).ceil(),
      itemBuilder: (context, index) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
              for (int i = index * getItensPerLine(context);
                  i < (index + 1) * getItensPerLine(context);
                  i++)
                if (i < confirmedsCombox.length)
                  Container(
                    width: (MediaQuery.of(context).size.width /
                            getItensPerLine(context)) -
                        2,
                    margin: const EdgeInsets.only(bottom: 5, right: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 220, 218, 218)),
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
                          confirmedCombox: confirmedsCombox[i],
                          confirmedComboxIndex: i,
                        ),
                        ConfirmedChildComboxItem(
                          confirmedCombox: confirmedsCombox[i],
                          indexOfConfirmedCombox: i,
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
