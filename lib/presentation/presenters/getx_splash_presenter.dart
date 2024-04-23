import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;

  GetxSplashPresenter({
    required this.loadSaleRequestTemp,
    required this.navigateTo,
    required this.loadEnterpriseData,
  });

  @override
  Future<void> checkApiSaleRequest({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      EnterpriseDataBuilder.enterpriseDataEntity =
          await loadEnterpriseData.load();

      // if (EnterpriseDataBuilder.enterpriseDataEntity == null) {
      //   navigateTo.navigate(
      //     pageRoute: PageRoutes.expansibleGroups,
      //     clear: true,
      //   );
      // }
      if (EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId == null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      }

      SaleRequestTempEntity? apiSaleRequestEntity;
      if (EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId != null) {
        apiSaleRequestEntity = await loadSaleRequestTemp.load(
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: "001", //aqui é só pra testar se a API está disponível, por isso um valor fixo
        );
      }

      if (apiSaleRequestEntity != null) {
        navigateTo.navigate(
          pageRoute: PageRoutes.expansibleGroups,
          clear: true,
        );
      } else {
        navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        );
      }
    } catch (error) {
      navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true);
    }
  }
}
