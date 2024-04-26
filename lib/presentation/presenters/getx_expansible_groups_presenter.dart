import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
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
  final LocalEnterpriseData localEnterpriseData;
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final LoadPrintedProducts loadPrintedProducts;
  final ClearExpansibleGroups clearExpansibleGroups;
  final ClearPrintedProducts clearPrintedProducts;
  final ClearSaleRequestTemp clearSaleRequestTemp;

  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.loadSaleRequestTemp,
    required this.loadPrintedProducts,
    required this.clearExpansibleGroups,
    required this.clearPrintedProducts,
    required this.clearSaleRequestTemp,
  });

  final _isLoading = false.obs;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
    notifyListeners();
  }

  final _mainError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  late final LoadExpansibleGroups loadExpansibleGroups;

  PrintedViewModel? _printedProducts;
  @override
  PrintedViewModel? get printedProducts => _printedProducts;

  List<ExpansibleGroupsViewModel> _expansibleGroups = [];
  @override
  List<ExpansibleGroupsViewModel> get expansibleGroups =>
      [..._expansibleGroups];

  SaleRequestTempViewModel? _saleRequestTemp;
  @override
  SaleRequestTempViewModel? get saleRequestTemp => _saleRequestTemp;
  set saleRequestTemp(SaleRequestTempViewModel? newValue) {
    _saleRequestTemp = newValue;
  }

  @override
  Future<void> getExpansibleGroups() async {
    try {
      isLoading = true;
      mainError = null;
      notifyListeners();

      final expansibleGroups = await loadExpansibleGroups.load();

      if (expansibleGroups != null) {
        _expansibleGroups.addAll(expansibleGroups
            .map((e) => ExpansibleGroupsViewModel.fromEntity(e))
            .toList());
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
      isLoading = false;
      throw DomainError.unexpected;
    } finally {
      notifyListeners();
    }
  }

  @override
  void goToProductsPage(int expansibleGroupId) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: expansibleGroupId,
    );
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }

  @override
  Future<void> goToSplashPage() async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
    _saleRequestTemp = null;
    _expansibleGroups = [];
    await clearEnterpriseData();
  }

  @override
  Future<void> clearEnterpriseData() async {
    final emptyEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName ?? "",
      enterpriseId: null,
      url: null,
    );
    EnterpriseDataBuilder.enterpriseDataEntity = emptyEntity;

    await localEnterpriseData.add(emptyEntity);
  }

  @override
  Future<void> load(String commandNumber) async {
    isLoading = true;
    mainError = null;
    _expansibleGroups = clearExpansibleGroups.clear();
    _printedProducts = clearPrintedProducts.clear();
    _saleRequestTemp = clearSaleRequestTemp.clear();
    notifyListeners();

    try {
      SaleRequestTempEntity? saleRequestTemp = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      if (saleRequestTemp != null) {
        _saleRequestTemp = SaleRequestTempViewModel.fromEntity(saleRequestTemp);

        await getExpansibleGroups();
        await getPrintedProducts(commandNumber);
      }
    } catch (error) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> getPrintedProducts(String commandNumber) async {
    isLoading = true;
    mainError = null;
    notifyListeners();

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.tryParse(commandNumber) ?? 0,
      );

      if (printedProducts != null) {
        _printedProducts = PrintedViewModel.fromEntity(printedProducts);
      }
    } catch (error) {
      throw UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void goToPrintedProductsPage() {
    navigateTo.navigate(
      pageRoute: PageRoutes.printedProducts,
    );
  }
}
