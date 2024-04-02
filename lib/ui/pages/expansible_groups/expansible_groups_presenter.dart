import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class ExpansibleGroupsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isLoadingStream;

  Future<void> getProducts();
}
