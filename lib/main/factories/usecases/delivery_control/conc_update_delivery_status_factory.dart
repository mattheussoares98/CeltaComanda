import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

RemoteConcDeliveryControl makeConcDeliveryControl() =>
    RemoteConcDeliveryControl(makeHttpAdapter());
