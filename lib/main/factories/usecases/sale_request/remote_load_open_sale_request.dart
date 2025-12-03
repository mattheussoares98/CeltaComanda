import 'package:clean_celta_mobile/main/factories/factories.dart';

import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';

LoadOpenSaleRequest makeRemoteLoadOpenSaleRequest() =>
    RemoteLoadOpenSaleRequest(
      httpAdapter: makeHttpAdapter(),
    );
