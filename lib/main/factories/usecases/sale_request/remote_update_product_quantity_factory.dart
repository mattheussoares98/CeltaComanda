import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

UpdateProductQuantity makeRemoteUpdateProductQuantity() =>
    RemoteUpdateProductQuantity(
      httpAdapter: makeHttpAdapter(),
    );
