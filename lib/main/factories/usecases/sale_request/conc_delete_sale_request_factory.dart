import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

DeleteSaleRequest makeConcDeleteSaleRequest() => ConcDeleteSaleRequest(
      httpAdapter: makeHttpAdapter(),
    );
