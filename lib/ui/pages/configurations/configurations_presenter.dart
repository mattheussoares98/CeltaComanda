import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ConfigurationsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get selectedPeoples;
  int? get selectedCommand;
  SellersViewModel? get selectedSeller;
  List<SellersViewModel> get sellers;

  Future<void> goToSplashPage();
  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
    required int userCode,
    required String password,
  });
  void updateSelectedPeoples(int? value);
  void updateSelectedCommand(int value);
  void updateSelectedSeller(SellersViewModel? seller);
}
