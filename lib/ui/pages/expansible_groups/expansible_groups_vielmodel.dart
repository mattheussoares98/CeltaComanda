import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String name;

  @override
  List get props => [name];

  const ExpansibleGroupsViewModel({
    required this.name,
  });
}
