import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';

class GetxExpansibleGroupsPresenter
    with ChangeNotifier
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final LoadPrintedProducts loadPrintedProducts;

  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.loadSaleRequestTemp,
    required this.loadPrintedProducts,
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
            .map((e) => ExpansibleGroupsViewModel(
                  Name: e.Name,
                  ExpansibleGroupId: e.ExpansibleGroupId,
                  ExpansibleGroupType: e.ExpansibleGroupType,
                  OrderClassification: e.OrderClassification,
                ))
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
    notifyListeners();

    try {
      SaleRequestTempEntity? saleRequestTemp = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      if (saleRequestTemp != null) {
        _saleRequestTemp = SaleRequestTempViewModel(
          Products: saleRequestTemp.Products.map((e) => ProductsViewModel(
                SaleRetailPraticed: e.SaleRetailPraticed.toString(),
                PackingAbbreviation: e.PackingAbbreviation,
                Name: e.Name,
                EanCode: e.EanCode.toString(),
                PriceLookupCode: e.PriceLookupCode,
                ProductsId: e.ProductsId,
              )).toList(),
          PersonalizedCode: saleRequestTemp.PersonalizedCode,
          EnterpriseId: saleRequestTemp.EnterpriseId,
          TotalLiquid: saleRequestTemp.TotalLiquid,
          DeliveryControl: saleRequestTemp.DeliveryControl,
          Comments: saleRequestTemp.Comments,
        );

        await getExpansibleGroups();
        await getPrintedProducts(commandNumber);
      }
    } catch (error) {
      mainError = UIError.commandNotAvailable;
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
      PrintedProductsEntity? saleRequestTemp =
          await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.tryParse(commandNumber) ?? 0,
      );

      if (saleRequestTemp != null) {
        print(saleRequestTemp);
      }
    } catch (error) {
      mainError = UIError.commandNotAvailable;
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
