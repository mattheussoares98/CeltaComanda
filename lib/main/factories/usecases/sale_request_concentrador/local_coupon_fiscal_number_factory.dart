import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

CouponFiscalNumber makeLocalCouponFiscalNumber() => LocalCouponFiscalNumber(
      hiveStorage: makeHiveAdapter(),
    );
