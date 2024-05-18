import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/main/factories/http/http_client_factory.dart';

GetProductComposition makeRemoteGetProductComposition() =>
    RemoteGetProductComposition(
      makeHttpAdapter(),
    );
