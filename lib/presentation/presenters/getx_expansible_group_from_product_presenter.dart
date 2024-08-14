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
  void changeObligatoryOptionIsSelected({
    required List<ExpansibleGroupFromProductViewModel> obligatoryOptionsShowing,
    required int selectedIndex,
    required InsertProductPresenter insertProductPresenter,
  }) {
    bool previousValue = obligatoryOptionsShowing[selectedIndex].selected;
    for (var group in obligatoryOptionsShowing) {
      group.selected = false;
    }

    if (previousValue == false) {
      obligatoryOptionsShowing[selectedIndex].selected = true;
    }

    insertProductPresenter.updateCanAdvanceIndex(this);
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
  void unselectAllObligatoryOptions() {
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
        .join("; ");

    final concatenateObligatoryOptions = _loadedObligatoryOptions
        .where((obligatoryOption) => obligatoryOption.selected)
        .where((e) => e.ProductInternalCodeOnErp.toInt() == internalCodeOnERP)
        .map((element) => element.GroupName)
        .join("; ");

    if (concatenateSelectedComments.isEmpty &&
        concatenateObligatoryOptions.isEmpty) {
      return null;
    } else {
      return "$concatenateSelectedComments$concatenateObligatoryOptions";
    }
  }

  @override
  bool productHasComment({
    required ProductsViewModel product,
    required int indexOfChild,
  }) {
    bool hasComment = false;
    if (product.childsComposition == null) {
      hasComment = _loadedComments
          .where(
            (e) =>
                e.ProductInternalCodeOnErp == product.InternalCodeOnERP &&
                e.ProductName == product.Name,
          )
          .isNotEmpty;
    } else if (product.childsComposition != null &&
        indexOfChild == product.childsComposition!.length) {
      return hasComment;
    } else {
      hasComment = _loadedComments
          .where(
            (e) =>
                e.ProductInternalCodeOnErp ==
                    product.childsComposition![indexOfChild]
                        .InternalCodeOnERPCodeChild! &&
                e.ProductName ==
                    product.childsComposition![indexOfChild].ChildName!,
          )
          .isNotEmpty;
    }
    return hasComment;
  }

  @override
  bool productHasObligatoryOption({
    required ProductsViewModel product,
    required int indexOfChild,
  }) {
    if (product.childsComposition == null) {
      return _loadedObligatoryOptions
          .where(
            (e) =>
                e.ProductInternalCodeOnErp == product.InternalCodeOnERP &&
                e.ProductName == product.Name,
          )
          .isNotEmpty;
    } else if (product.childsComposition != null &&
        indexOfChild == product.childsComposition!.length) {
      return false;
    } else {
      return _loadedObligatoryOptions
          .where(
            (e) =>
                e.ProductInternalCodeOnErp ==
                    product.childsComposition![indexOfChild]
                        .InternalCodeOnERPCodeChild! &&
                e.ProductName ==
                    product.childsComposition![indexOfChild].ChildName!,
          )
          .isNotEmpty;
    }
  }
}
