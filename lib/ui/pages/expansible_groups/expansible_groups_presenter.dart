import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isLoadingStream;

  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream;

  Future<void> loadExpansibleGroups();
}
