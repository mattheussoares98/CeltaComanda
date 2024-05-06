import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter with ChangeNotifier implements HomePresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final TicketIsPermitted ticketIsPermitted;

  GetxHomePresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.ticketIsPermitted,
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

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);

    //chamar método pra limpar grupos expansíveis
    //_expansibleGroups = [];
    printedProductsPresenter.clear();
    saleRequestTempPresenter.clear();
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
  Future<void> load({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    //limpar grupos expansíveis
    // ExpansibleGroupsPresenter().clear();
    _commandNumber = commandNumber;
    printedProductsPresenter.clear();
    saleRequestTempPresenter.clear();
    notifyListeners();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      //chamar método pra carregar grupos expansíveis
      // await ExpansibleGroupsPresenter().load(
      //   commandNumber: commandNumber,
      //   printedProductsPresenter: printedProductsPresenter,
      //   saleRequestTempPresenter: saleRequestTempPresenter,
      // );

      await saleRequestTempPresenter.load(commandNumber);
      await printedProductsPresenter.load(commandNumber);
    } on DomainError catch (error) {
      _commandNumber = null;
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void clear() {
    //limpar todos dados das 3 telas
    // PrintedProductsPresenter().clear();
    // SaleRequestTempPresenter().clear();
    // ExpansibleGroupsPresenter().clear();
    _commandNumber = null;
  }

  String? _commandNumber;
  @override
  String? get commandNumber => _commandNumber;
}
