import '../../../../data/usecases/payment/payment.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/factories.dart';

PaidInformations makeLocalPaidInformations() => LocalPaidInformations(
      hiveStorage: makeHiveAdapter(),
    );
