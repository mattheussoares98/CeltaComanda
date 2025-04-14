import 'package:equatable/equatable.dart';

import '../../ui/pages/pages.dart';

class LoadedMenuModel extends Equatable {
  final String enterpriseName;
  final List<LoadedMenuViewModel> menu;

  const LoadedMenuModel({
    required this.enterpriseName,
    required this.menu,
  });

  @override
  List<Object?> get props => [menu, enterpriseName];

  Map<String, dynamic> toJson() => {
        "enterpriseName": enterpriseName,
        "menu": menu.map((e) => e.toJson()).toList(),
      };

  factory LoadedMenuModel.fromJson(Map<String, dynamic> json) =>
      LoadedMenuModel(
        enterpriseName: json["enterpriseName"],
        menu: (json["menu"] as List)
            .map((e) => LoadedMenuViewModel.fromJson(e))
            .toList(),
      );
}
