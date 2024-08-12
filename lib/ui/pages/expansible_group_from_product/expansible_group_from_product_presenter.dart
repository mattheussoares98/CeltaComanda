import 'package:flutter/material.dart';

import '../pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupFromProductPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<ExpansibleGroupFromProductViewModel> get loadedComments;
  List<ExpansibleGroupFromProductViewModel> get loadedObligatoryOptions;

  Future<void> loadCommentsAndObligatoryOptions(List<ProductsViewModel> loadedProducts);
  Future<void> changeCommentIsSelected(
    ExpansibleGroupFromProductViewModel comment,
  );
  void unselectAllComments();
  String? getConcatenateSelectedComments(int internalCodeOnERP);
  void updateSelectedComments({
    required String? comments,
    required int internalCodeOnERP,
  });
  bool productHasComment({
    required int internalCodeOnERP,
    required String productName,
  });
}
