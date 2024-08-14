import 'package:flutter/material.dart';

import '../pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupFromProductPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<ExpansibleGroupFromProductViewModel> get loadedComments;
  List<ExpansibleGroupFromProductViewModel> get loadedObligatoryOptions;

  Future<void> loadCommentsAndObligatoryOptions(
      List<ProductsViewModel> loadedProducts);
  Future<void> changeCommentIsSelected(
    ExpansibleGroupFromProductViewModel comment,
  );
  Future<void> changeObligatoryOptionIsSelected(
    ExpansibleGroupFromProductViewModel comment,
  );
  void unselectAllComments();
  void unselectAllObligatoryOptions();
  String? getConcatenateSelectedCommentsAndObligatoryOptions(
      int internalCodeOnERP);
  bool productHasComment({
    required ProductsViewModel product,
    required int indexOfChild,
  });
  bool productHasObligatoryOption({
    required ProductsViewModel product,
    required int indexOfChild,
  });
}
