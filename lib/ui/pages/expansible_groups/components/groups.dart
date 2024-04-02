import 'dart:math';

import 'package:flutter/material.dart';

import '../../pages.dart';

class GroupsItems extends StatelessWidget {
  final List<ExpansibleGroupsViewModel> expansibleGroupsViewModel;
  const GroupsItems({
    required this.expansibleGroupsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expansibleGroupsViewModel.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final group = expansibleGroupsViewModel[index];
        
        final random = Random();
        final color = Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1,
        );

        return Container(
          margin: const EdgeInsets.all(8),
          height: 100,
          color: color,
          child: Center(
            child: Text(
              group.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
