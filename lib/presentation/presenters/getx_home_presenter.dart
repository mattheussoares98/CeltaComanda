import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter with ChangeNotifier implements HomePresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final TicketIsPermitted ticketIsPermitted;
  final LoadExpansibleGroups loadExpansibleGroups;
  final LocalCommandData localCommandData;

  GetxHomePresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.ticketIsPermitted,
    required this.localCommandData,
  });

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
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);

    _commandNumber = null;
    menuPresenter.clear();
    printedProductsPresenter.clear();
    cartPresenter.clear();
    await clearEnterpriseData();
  }

  @override
  Future<void> clearEnterpriseData() async {
    final emptyEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName ?? "",
      enterpriseId: null,
      url: null,
      concentradorUrl: null,
    );
    EnterpriseDataBuilder.enterpriseDataEntity = emptyEntity;

    await localEnterpriseData.add(emptyEntity);
  }

  String? _commandNumber;
  @override
  String? get commandNumber => _commandNumber;
  @override
  void updateCommandNumber(String? value) {
    _commandNumber = value;
  }

  @override
  void onChangePage({
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) {
    menuPresenter.updateSelectedProduct(
      selectedProduct: null,
      commentsPresenter: commentsPresenter,
    );

    printedProductsPresenter.updateCanCancelProducts(false);
  }

  @override
  Future<void> getLocalCommandData() async {
    try {
      isLoading = true;
      mainError = null;

      CommandEntity? loadedCommand = await localCommandData.load();

      if (loadedCommand == null) {
        throw Exception();
      }

      _isFixedCommandNumber = loadedCommand.isFixedCommandNumber;
      _commandNumber = loadedCommand.commandNumber;
    } catch (e) {
      mainError = UIError.unexpected;
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

  bool _isFixedCommandNumber = false;
  @override
  bool get isFixedCommandNumber => _isFixedCommandNumber;

  @override
  Future<void> updateIsFixedCommandNumber() async {
    isLoading = true;
    mainError = null;

    try {
      _isFixedCommandNumber = !_isFixedCommandNumber;

      await localCommandData.update(
        CommandEntity(
          commandNumber: _commandNumber,
          isFixedCommandNumber: _isFixedCommandNumber,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  bool get isGeneratingVersionToRede => false;
}
