import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import '../../main/builders/builders.dart';
import '../../ui/pages/pages.dart';

class GetxSaleRequestTempPresenter
    with ChangeNotifier
    implements SaleRequestTempPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;

  GetxSaleRequestTempPresenter({
    required this.loadSaleRequestTemp,
  });

  SaleRequestTempViewModel? _saleRequestTemp;
  @override
  SaleRequestTempViewModel? get saleRequestTemp => _saleRequestTemp;
  set saleRequestTemp(SaleRequestTempViewModel? newValue) {
    _saleRequestTemp = newValue;
  }

  final _isLoading = Rx<bool>(false);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Future<void> load(String commandNumber) async {
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
}
