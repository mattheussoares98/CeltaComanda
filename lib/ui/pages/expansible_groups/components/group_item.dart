import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../presentation/presenters/presenters.dart';
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
        Provider.of<GetxExpansibleGroupsPresenter>(context, listen: false);

    return GestureDetector(
      onTap: () {
        presenter.goToProductsPage(expansibleGroupsViewModel.toEntity());
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Text(
            expansibleGroupsViewModel.Name,
            style: const TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 3,
                  offset: Offset(2, 2),
                ),
              ],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
