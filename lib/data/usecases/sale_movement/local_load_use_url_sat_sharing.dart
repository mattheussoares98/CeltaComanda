import 'dart:math';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';

class LocalLoadUseUrlSatSharing implements LoadUseUrlSatSharing {
  @override
  bool getUse() {
    int? urlSatSharing = EnterpriseBuilder.entity
        ?.enterpriseConcentradorParametersEntity?.urlSATSharingTotalCouponGroup;
    if (urlSatSharing == null) {
      return true;
    } else if (urlSatSharing == 100) {
      return true;
    } else if (urlSatSharing == 99) {
      return false;
    } else {
      return Random().nextInt(101) <= urlSatSharing;
    }
  }
}
