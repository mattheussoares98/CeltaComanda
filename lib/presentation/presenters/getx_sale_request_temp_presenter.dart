import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSaleRequestTempPresenter
    with ChangeNotifier
    implements SaleRequestTempPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final UpdateProductQuantity updateProductQuantity;

  GetxSaleRequestTempPresenter({
    required this.loadSaleRequestTemp,
    required this.updateProductQuantity,
  });

  SaleRequestTempViewModel? _saleRequestTemp;
  @override
  SaleRequestTempViewModel? get saleRequestTemp => _saleRequestTemp;
  set saleRequestTemp(SaleRequestTempViewModel? newValue) {
    _saleRequestTemp = newValue;
  }

  final _isLoading = Rx<bool>(false);
  set isLoading(bool value) => _isLoading.value = value;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

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
        _saleRequestTemp = SaleRequestTempViewModel.fromEntity(saleRequestTemp);
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  void clear() {
    _saleRequestTemp = null;
  }

  @override
  Future<void> addProductQuantity({
    required String url,
    required int saleRequestProductTempId,
  }) async {
    isLoading = true;
    mainError = null;
    notifyListeners();
    try {
      await updateProductQuantity.add(
        url: url,
        saleRequestProductTempId: saleRequestProductTempId,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> subtractProductQuantity({
    required String url,
    required int saleRequestProductTempId,
  }) async {
    isLoading = true;
    mainError = null;
    notifyListeners();
    try {
      await updateProductQuantity.subtract(
        url: url,
        saleRequestProductTempId: saleRequestProductTempId,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
