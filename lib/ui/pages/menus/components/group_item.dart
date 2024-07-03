import 'package:flutter/material.dart';

import '../../pages.dart';

class GroupItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  final bool groupIsSelected;
  const GroupItem({
    required this.expansibleGroupsViewModel,
    required this.groupIsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const style = TextStyle(fontSize: 16);
        final textSpan =
            TextSpan(text: expansibleGroupsViewModel.Name, style: style);
        final textPainter = TextPainter(
            text: textSpan, textDirection: TextDirection.ltr, maxLines: 4);
        textPainter.layout(maxWidth: constraints.maxWidth);

        return Center(
          child: FittedBox(
            child: Text(
              expansibleGroupsViewModel.Name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: groupIsSelected ? Colors.white : Colors.grey,
                fontSize: 5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
