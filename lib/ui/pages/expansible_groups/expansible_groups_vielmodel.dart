import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ExpansibleGroupsViewModel extends Equatable {
  final String id;
  final Color color;

  @override
  List get props => [id, color];

  const ExpansibleGroupsViewModel({
    required this.id,
    required this.color,
  });
}
