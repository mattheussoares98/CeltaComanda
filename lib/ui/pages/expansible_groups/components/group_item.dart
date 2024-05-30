import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../expansible_groups/expansible_groups.dart';

class GroupItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  final int groupIndex;
  const GroupItem({
    required this.expansibleGroupsViewModel,
    required this.groupIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter =
        Provider.of<ExpansibleGroupsPresenter>(context, listen: false);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const style = TextStyle(fontSize: 16);
        final textSpan =
            TextSpan(text: expansibleGroupsViewModel.Name, style: style);
        final textPainter = TextPainter(
            text: textSpan, textDirection: TextDirection.ltr, maxLines: 4);
        textPainter.layout(maxWidth: constraints.maxWidth);
    
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: FittedBox(
              child: Text(
                expansibleGroupsViewModel.Name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: groupIndex == presenter.indexOfSelectedGroup
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
