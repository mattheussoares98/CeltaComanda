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
  final LoadExpansibleGroups loadExpansibleGroups;
  final LocalCommandData localCommandData;
  final UserValidations userValidations;

  GetxHomePresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.ticketIsPermitted,
    required this.localCommandData,
    required this.userValidations,
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

  @override
  Future<void> loadCommandData({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required CommentsPresenter commentsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await menuPresenter.getGroupsAndProducts(
        commandNumber: commandNumber ?? "001",
        commentsPresenter: commentsPresenter,
      );

      if (isFixedCommandNumber && commandNumber != null) {
        await cartPresenter.loadSaleRequest(commandNumber!);
        await printedProductsPresenter.loadPrinted(homePresenter);
      }
      notifyListeners();
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }

  @override
  void goToPrintedProductsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.printedProducts);
  }

  @override
  Future<bool> updateFixedCommandNumber({
    required int newFixedCommandNumber,
    required int userPersonalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: newFixedCommandNumber.toString(),
      );

      await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      final commandNumber = newFixedCommandNumber.toString().padLeft(3, '0');

      updateCommandNumber(commandNumber);
      notifyListeners();
      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        default:
          mainError = UIError.unexpected;
      }
      return false;
    } finally {
      isLoading = false;
    }
  }
}
