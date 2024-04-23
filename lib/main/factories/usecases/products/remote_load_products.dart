import 'package:clean_celta_mobile/data/usecases/products/remote_load_products.dart';
import 'package:clean_celta_mobile/main/factories/factories.dart';

import '../../../../domain/usecases/usecases.dart';

LoadProducts makeRemoteLoadProducts() => RemoteLoadProducts(
      httpAdapter: makeHttpAdapter(),
    );
