import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SearchDataOfOtherCommandNumber extends StatelessWidget {
  const SearchDataOfOtherCommandNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () async {
          writeCommandNumber(
            context: context,
            onWriteCommandAction: OnWriteCommand.loadPrintedProducts,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: FittedBox(
            child: Text(
              R.string.searchDataOfOtherCommandNumber,
              style: TextStyle(
                fontSize: getStringSize(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
