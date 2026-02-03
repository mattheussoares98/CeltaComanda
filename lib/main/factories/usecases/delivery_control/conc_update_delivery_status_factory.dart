import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

ConcUpdateDeliveryStatus makeConcUpdateDeliveryStatus() =>
    ConcUpdateDeliveryStatus(makeHttpAdapter());
