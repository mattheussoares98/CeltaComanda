import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

class CartViewModel extends Equatable {
  final String name;

  @override
  List get props => [name];

  const CartViewModel({
    required this.name,
  });
}
