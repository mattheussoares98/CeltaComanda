import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';
import '../../database/database.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcentratorLoadImages implements LoadImages {
  final HiveStorage hiveStorage;
  final HttpClient httpClient;

  ConcentratorLoadImages({
    required this.hiveStorage,
    required this.httpClient,
  });

  @override
  Future<List<ImageModel>> load({required bool getLocalImages}) async {
    List<String> plusAndEans = [];
    try {
      if (getLocalImages) {
        final localImages = await hiveStorage.get(CacheKeys.images.name);

        return (localImages as List)
            .map((e) => ImageModel.fromJson(e))
            .toList();
      }
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
        url: "$concentratorUrl/api/APIImport/GetImages",
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );

      plusAndEans =
          response.map<String>((e) => e.toString()).toList().cast<String>();
      final loadedImages = await _loadImages(plusAndEans);

      await hiveStorage.put(
          CacheKeys.images.name, loadedImages.map((e) => e.toJson()).toList());
      return loadedImages;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<List<ImageModel>> _loadImages(List<String> imagesNames) async {
    final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
    final List<ImageModel> images = [];
    for (var pluOrEan in imagesNames) {
      final maxSizeInBytes = 1 * 1024 * 1024;
      final client = http.Client();
      final url = "$concentratorUrl/Images/$pluOrEan";
      final request = http.Request('GET', Uri.parse(url));
      final response =
          await client.send(request) /* .timeout(Duration(seconds: 2)) */;
      StreamSubscription<List<int>>? subscription;
      int totalBytes = 0;
      final completer = Completer<void>();
      final List<int> buffer = [];
      subscription = response.stream.listen(
        (List<int> data) {
          totalBytes += data.length;
          buffer.addAll(data);

          if (totalBytes > maxSizeInBytes) {
            subscription?.cancel();
            completer.completeError('Tamanho máximo da imagem excedido $url');
          }
        },
        onDone: () {
          images.add(ImageModel(
            pluOrEan: pluOrEan,
            image: Uint8List.fromList(buffer),
            keyIsEan: pluOrEan.length > 11,
          ));
          completer.complete();
        },
        onError: (error) {
          completer.completeError(error);
        },
        cancelOnError: true,
      );
    }
    return images;
  }
}
