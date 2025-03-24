import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class BlockUseAppIfIsOutdatedSwitch extends StatelessWidget {
  final bool blockUseAppIfIsOutdated;
  final void Function() changeBlockAppIfIsOutdated;
  const BlockUseAppIfIsOutdatedSwitch({
    required this.blockUseAppIfIsOutdated,
    required this.changeBlockAppIfIsOutdated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: changeBlockAppIfIsOutdated,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(R.string.blockUseAppIfIsOutdated)),
              Switch(
                value: blockUseAppIfIsOutdated,
                onChanged: (_) {
                  changeBlockAppIfIsOutdated();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
