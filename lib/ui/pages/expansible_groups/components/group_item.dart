import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../expansible_groups/expansible_groups.dart';

class GroupItem extends StatelessWidget {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  const GroupItem({
    required this.expansibleGroupsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );

    final presenter = Provider.of<ExpansibleGroupsPresenter>(context);

    return GestureDetector(
      onTap: presenter.goToProductsPage,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 100,
        color: color,
        child: Center(
          child: Text(
            expansibleGroupsViewModel.name,
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
