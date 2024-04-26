import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPrintedProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PrintedProductsPresenter {
  final UserValidations userValidations;

  GetxPrintedProductsPresenter({
    required this.userValidations,
  });

  @override
  Future<bool> isValidPasswordAndCanCancel({
    required int personalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      bool canCancel = false;
      if (isValidPassword) {
        canCancel = await userValidations.canCancel(
          personalizedCode: personalizedCode,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        );
      }
      if (!canCancel) {
        throw DomainError.accessDenied;
      }

      return canCancel;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        case DomainError.accessDenied:
          mainError = UIError.accessDenied;
          break;
        default:
          mainError = UIError.unexpected;
      }

      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> removeProduct() async {}
}
