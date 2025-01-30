import 'package:equatable/equatable.dart';

import '../pages.dart';

class LoadedMenuViewModel extends Equatable {
  final ExpansibleGroupsViewModel expansibleGroupsViewModel;
  final List<ProductsViewModel> productsViewModel;

  const LoadedMenuViewModel({
    required this.expansibleGroupsViewModel,
    required this.productsViewModel,
  });

  @override
  List<Object?> get props => [expansibleGroupsViewModel, productsViewModel];

  factory LoadedMenuViewModel.fromJson(Map<String, dynamic> json) =>
      LoadedMenuViewModel(
        expansibleGroupsViewModel: ExpansibleGroupsViewModel.fromJson(
            json['expansibleGroupsViewModel']),
        productsViewModel: (json['productsViewModel'] as List)
            .map((e) => ProductsViewModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'expansibleGroupsViewModel': expansibleGroupsViewModel.toJson(),
        'productsViewModel': productsViewModel.map((e) => e.toJson()).toList(),
      };
}
