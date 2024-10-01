import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCovenantPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CovenantPresenter {
  GetxCovenantPresenter();

  @override
  Future<void> getCustomer(String value) async {
    try {
      // /* final jsonData =  */ await soapAdapter.post(
      //   parameters: {
      //     "filters": json.encode({
      //       "crossIdentity": EnterpriseDataBuilder.enterpriseDataEntity!
      //           .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
      //       "customerData": value,
      //       "customerDataType": searchTypeInt,
      //       "enterpriseCode":
      //           EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
      //     }),
      //   },
      //   typeOfResponse: "GetCustomerJsonResponse",
      //   soapAction: "GetCustomerJson",
      //   serviceASMX: "CeltaCustomerService.asmx",
      //   typeOfResult: "GetCustomerJsonResult",
      // );
    } catch (e) {
      e;
    }
  }
}
