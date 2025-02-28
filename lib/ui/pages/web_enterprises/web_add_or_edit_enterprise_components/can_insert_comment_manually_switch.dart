import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CanInsertCommentManuallySwitch extends StatelessWidget {
  final bool canInsertCommentManually;
  final void Function() changeCanInsertCommentManually;
  const CanInsertCommentManuallySwitch({
    required this.canInsertCommentManually,
    required this.changeCanInsertCommentManually,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          changeCanInsertCommentManually();
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
              Expanded(child: Text(R.string.canInsertCommentManually)),
              Switch(
                value: canInsertCommentManually,
                onChanged: (_) {
                  changeCanInsertCommentManually();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
