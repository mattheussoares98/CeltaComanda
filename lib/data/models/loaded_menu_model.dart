import 'package:equatable/equatable.dart';

import '../../ui/pages/pages.dart';

class LoadedMenuModel extends Equatable {
  final List<LoadedMenuViewModel> menu;
  final String enterpriseName;

  const LoadedMenuModel({
    required this.menu,
    required this.enterpriseName,
  });

  @override
  List<Object?> get props => [menu, enterpriseName];

  Map<String, dynamic> toJson() => {
        "menu": menu.map((e) => e.toJson()).toList(),
        "enterpriseName": enterpriseName,
      };

  factory LoadedMenuModel.fromJson(Map<String, dynamic> json) =>
      LoadedMenuModel(
        menu: (json["menu"] as List)
            .map((e) => LoadedMenuViewModel.fromJson(e))
            .toList(),
        enterpriseName: json["enterpriseName"],
      );
}
