import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String id;
  final String name;
  // final Color color;

  @override
  List get props => [
        id,
        name /* color */
      ];

  const ExpansibleGroupsViewModel({
    required this.id,
    required this.name,
    // required this.color,
  });
}
