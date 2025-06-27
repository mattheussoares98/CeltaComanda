import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SearchDataOfOtherCommandNumber extends StatelessWidget {
  const SearchDataOfOtherCommandNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () async {
          WriteNumber.writeAndReturnNumber(
            ActionType.loadPrintedProducts,
            title: R.string.msgInsertCommandNumber,
            label: R.string.commandNumber,
            hint: R.string.commandNumber,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: FittedBox(
            child: Text(
              R.string.searchDataOfOtherCommandNumber,
              style: TextStyle(
                fontSize: StringSize.size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
