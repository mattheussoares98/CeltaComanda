import 'package:clean_celta_mobile/data/usecases/sale_request_temp/local_print_request.dart';
import 'package:clean_celta_mobile/main/factories/cache/cache.dart';

LocalPrintRequest makeLocalPrintRequest() => LocalPrintRequest(
      hiveStorage: makeHiveAdapter(),
    );
