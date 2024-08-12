import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';

class GetxExpansibleGroupFromProductPresenter
    with ChangeNotifier
    implements ExpansibleGroupFromProductPresenter {
  final LoadExpansibleGroupsByProductsCodes
      loadExpansibleGroupsFromProductsComplete;

  GetxExpansibleGroupFromProductPresenter({
    required this.loadExpansibleGroupsFromProductsComplete,
  });

  List<ExpansibleGroupFromProductViewModel> _loadedComments = [];
  @override
  List<ExpansibleGroupFromProductViewModel> get loadedComments =>
      _loadedComments;

  List<ExpansibleGroupFromProductViewModel> _loadedObligatoryOptions = [];
  @override
  List<ExpansibleGroupFromProductViewModel> get loadedObligatoryOptions =>
      _loadedObligatoryOptions;

  List<int> _getAllInternalCodes(List<ProductsViewModel> allProducts) {
    List<int> allInternalCodes = [];
    for (var product in allProducts) {
      allInternalCodes.add(product.InternalCodeOnERP!.toInt());

      if (product.childsComposition != null) {
        for (var child in product.childsComposition!) {
          allInternalCodes.add(child.InternalCodeOnERPCodeChild!.toInt());
        }
      }
    }

    return allInternalCodes;
  }

  @override
  Future<void> loadCommentsAndObligatoryOptions(
      List<ProductsViewModel> loadedProducts) async {
    isLoading = true;
    mainError = null;

    try {
      final optionalGroups =
          await loadExpansibleGroupsFromProductsComplete.load(
        expansibleGroupType: 22, //comentários
        productsPackingInternalCodesOnErp: _getAllInternalCodes(loadedProducts),
      );

      _loadedComments = optionalGroups
          .map((e) => ExpansibleGroupFromProductViewModel
                  .fromExpansibleGroupsFromProductsCompleteEntity(
                e,
              ))
          .toList();

      final obligatoryOptions =
          await loadExpansibleGroupsFromProductsComplete.load(
        expansibleGroupType: 23, //opcionais obrigatórios
        productsPackingInternalCodesOnErp: _getAllInternalCodes(loadedProducts),
      );

      _loadedObligatoryOptions = obligatoryOptions
          .map((e) => ExpansibleGroupFromProductViewModel
                  .fromExpansibleGroupsFromProductsCompleteEntity(
                e,
              ))
          .toList();
    } catch (e) {
      mainError = UIError.unexpected;
      _loadedComments = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> changeCommentIsSelected(
      ExpansibleGroupFromProductViewModel comment) async {
    int index = _loadedComments.indexOf(comment);
    _loadedComments[index].selected = !_loadedComments[index].selected;
  }

  @override
  Future<void> changeObligatoryOptionIsSelected(
    ExpansibleGroupFromProductViewModel group,
  ) async {
    int index = _loadedObligatoryOptions.indexOf(group);
    _loadedObligatoryOptions[index].selected =
        !_loadedObligatoryOptions[index].selected;
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;
  final _mainError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  @override
  void unselectAllComments() {
    for (var comment in _loadedComments) {
      comment.selected = false;
    }
  }

  @override
  void unselectAllOptionalObligatory() {
    for (var obligatoryOptional in _loadedObligatoryOptions) {
      obligatoryOptional.selected = false;
    }
  }

  @override
  String? getConcatenateSelectedCommentsAndObligatoryOptions(
    int internalCodeOnERP,
  ) {
    final concatenateSelectedComments = _loadedComments
        .where((comment) => comment.selected)
        .where((e) => e.ProductInternalCodeOnErp.toInt() == internalCodeOnERP)
        .map((element) => element.GroupName)
        .join("\n");

    final concatenateObligatoryOptions = _loadedObligatoryOptions
        .where((obligatoryOption) => obligatoryOption.selected)
        .where((e) => e.ProductInternalCodeOnErp.toInt() == internalCodeOnERP)
        .map((element) => element.GroupName)
        .join("\n");

    if (concatenateSelectedComments.isEmpty &&
        concatenateObligatoryOptions.isEmpty) {
      return null;
    } else {
      return concatenateSelectedComments + concatenateObligatoryOptions;
    }
  }

  @override
  void updateSelectedComments({
    required String? comments,
    required int internalCodeOnERP,
  }) {
    for (var loadedComment in loadedComments) {
      loadedComment.selected = false;

      loadedComment.selected = comments != null &&
          comments.contains(loadedComment.GroupName) &&
          loadedComment.ProductInternalCodeOnErp.toInt() == internalCodeOnERP;
    }
    notifyListeners();
  }

  @override
  bool productHasComment({
    required int internalCodeOnERP,
    required String productName,
  }) {
    return loadedComments
        .where((e) =>
            e.ProductInternalCodeOnErp.toInt() == internalCodeOnERP &&
            e.ProductName == productName)
        .isNotEmpty;
  }
}
