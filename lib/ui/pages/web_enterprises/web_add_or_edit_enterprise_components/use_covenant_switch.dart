import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class UseCovenantSwitch extends StatelessWidget {
  final bool useCovenant;
  final void Function() changeUseCovenant;
  const UseCovenantSwitch({
    required this.useCovenant,
    required this.changeUseCovenant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          changeUseCovenant();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(R.string.enableCovenant)),
              Switch(
                value: useCovenant,
                onChanged: (_) {
                  changeUseCovenant();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
