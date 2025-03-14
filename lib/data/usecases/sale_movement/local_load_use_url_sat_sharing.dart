import 'dart:math';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';

class LocalLoadUseUrlSatSharing implements LoadUseUrlSatSharing {
  @override
  bool getUse(int? cpfCnpj) {
    int? urlSatSharing = EnterpriseBuilder.entity
        ?.enterpriseConcentradorParametersEntity?.urlSATSharingTotalCouponGroup;

    if (cpfCnpj != null) {
      return false;
    } else if (urlSatSharing == null) {
      return false;
    } else if (urlSatSharing == 100) {
      return false;
    } else if (urlSatSharing == 99) {
      return true;
    } else {
      return Random().nextInt(101) <= urlSatSharing;
    }
  }
}
