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
    // final random = Random();
    // final color = Color.fromRGBO(
    //   random.nextInt(256),
    //   random.nextInt(256),
    //   random.nextInt(256),
    //   1,
    // );

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

          return Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  expansibleGroupsViewModel.Name,
                  textAlign: TextAlign.center,
                  // maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(2, 2),
                      ),
                    ],
                    fontSize: 17,
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
