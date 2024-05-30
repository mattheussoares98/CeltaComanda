import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../expansible_groups/expansible_groups.dart';

class GroupItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  const GroupItem({
    required this.expansibleGroupsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter =
        Provider.of<ExpansibleGroupsPresenter>(context, listen: false);

    return GestureDetector(
      onTap: () {
        presenter.goToProductsPage(expansibleGroupsViewModel.toEntity());
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const style = TextStyle(fontSize: 16);
          final textSpan =
              TextSpan(text: expansibleGroupsViewModel.Name, style: style);
          final textPainter = TextPainter(
              text: textSpan, textDirection: TextDirection.ltr, maxLines: 4);
          textPainter.layout(maxWidth: constraints.maxWidth);

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: FittedBox(
                child: Text(
                  expansibleGroupsViewModel.Name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
