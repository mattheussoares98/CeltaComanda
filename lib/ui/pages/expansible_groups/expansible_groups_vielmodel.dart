import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String id;
  final String name;

  @override
  List get props => [id, name];

  const ExpansibleGroupsViewModel({
    required this.id,
    required this.name,
  });
}
