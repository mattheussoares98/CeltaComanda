import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxExpansibleGroupsPresenter
    with ChangeNotifier
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  final TicketIsPermitted ticketIsPermitted;
  final SearchProductByCode searchProductByCode;
  final LoadExpansibleGroups loadExpansibleGroups;

  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.ticketIsPermitted,
    required this.searchProductByCode,
  });

  @override
  ProductsViewModel? get searchedProduct => _searchedProduct;
  ProductsViewModel? _searchedProduct;

  final List<ExpansibleGroupsViewModel> _expansibleGroups = [];
  @override
  List<ExpansibleGroupsViewModel> get expansibleGroups =>
      [..._expansibleGroups];

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  Future<void> load(String commandNumber) async {
    clear();
    notifyListeners();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      final expansibleGroups = await loadExpansibleGroups.load();

      if (expansibleGroups != null) {
        _expansibleGroups.addAll(expansibleGroups
            .map((e) => ExpansibleGroupsViewModel.fromEntity(e))
            .toList());
      }
      notifyListeners();
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          throw DomainError.commandNotAvailable;
        default:
          throw DomainError.unexpected;
      }
    }
  }

  @override
  void clear() {
    _expansibleGroups.clear();
    _searchedProduct = null;
  }

  @override
  Future<void> searchProduct(String value) async {
    _searchedProduct = null;
    notifyListeners();
    isLoading = true;
    mainError = null;

    if (value.toString().length <= 7) {
      value = _formatPlu(value);
    }

    try {
      final product = await searchProductByCode.search(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        value: value,
      );

      if (product != null) {
        _searchedProduct = ProductsViewModel.fromEntity(product);
        notifyListeners();
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.productNotFound:
          mainError = UIError.productNotFound;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  String _formatPlu(String number) {
    // Adiciona zeros à esquerda para garantir que tenha pelo menos 6 dígitos
    String paddedNumber = number.padLeft(6, '0');

    // Separa os primeiros 5 dígitos e o último dígito
    String firstPart = paddedNumber.substring(0, 5);
    String lastPart = paddedNumber.substring(5);
    final plu = '$firstPart-$lastPart';

    // Retorna a variável formatada
    return plu;
  }
}
