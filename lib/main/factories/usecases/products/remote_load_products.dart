import '../../../../data/usecases/products/remote_load_products.dart';
import '../../../../main/factories/factories.dart';

import '../../../../domain/usecases/usecases.dart';

LoadProducts makeRemoteLoadProducts() => RemoteLoadProducts(
      httpAdapter: makeHttpAdapter(),
    );
