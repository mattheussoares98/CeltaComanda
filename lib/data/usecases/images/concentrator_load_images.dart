import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
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

  int counter = 0;

  @override
  Future<List<ImageModel>> load({
    required bool getLocalImages,
    required List<String> updatedImages,
  }) async {
    try {
      final localImagesJson = await hiveStorage.get(CacheKeys.images.name);
      var localImages = localImagesJson == null
          ? <ImageModel>[]
          : (localImagesJson as List)
              .map((e) => ImageModel.fromJson(e))
              .toList();

      // if (getLocalImages) {
      //   return localImages;
      // } else if (updatedImages.isNotEmpty && localImages.isNotEmpty) {
      //   final newImages = await _loadConcentratorImages(updatedImages);

      //   for (var updatedImage in newImages) {
      //     int indexInLocalImages = localImages
      //         .indexWhere((e) => e.pluOrEan == updatedImage.pluOrEan);

      //     if (indexInLocalImages != -1) {
      //       localImages[indexInLocalImages] = updatedImage;
      //     } else {
      //       localImages.add(updatedImage);
      //     }
      //   }

      //   await hiveStorage.delete(CacheKeys.images.name);
      //   await hiveStorage.put(
      //     CacheKeys.images.name,
      //     localImages.map((e) => e.toJson()).toList(),
      //   );

      //   return localImages;
      // }
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
        url: "$concentratorUrl/api/APIImport/GetImages",
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );

      final plusAndEansThatContainsImagesInConcentrator = (response as List)
          .map<String>((e) => e.toString())
          .toList()
          .cast<String>();

      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );

      final loadedImages = await _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );
      await Future.delayed(Duration(minutes: 2));
      await hiveStorage.delete(CacheKeys.images.name);
      await hiveStorage.put(
        CacheKeys.images.name,
        loadedImages.map((e) => e.toJson()).toList(),
      );
      return loadedImages;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<List<ImageModel>> _loadConcentratorImages(
      List<String> imagesNames) async {
    final List<ImageModel> images = [];

    final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
    final enterpriseImage = await _loadEnterpriseConcentratorImage();

    if (enterpriseImage != null) {
      images.add(enterpriseImage);
    }
    debugPrint("começou");
    for (var pluOrEan in imagesNames) {
      try {
        final maxSizeInBytes = 1 * 1024 * 1024;
        final client = http.Client();
        final url = "$concentratorUrl/Images/$pluOrEan";
        final request = http.Request('GET', Uri.parse(url));
        final response = await client.send(request);

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
            images.add(
              ImageModel(
                pluOrEan: pluOrEan,
                image: Uint8List.fromList(buffer),
                keyIsEan: pluOrEan.length > 11,
                isEnterpriseImage: false,
              ),
            );
            completer.complete();
          },
          onError: (error) {
            completer.completeError(error);
          },
          cancelOnError: true,
        );

        // Wait for the download to complete or fail before moving to the next image
        await completer.future;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    counter++;
    debugPrint("download número: $counter. Qtd imagens: ${images.length}");

    return images;
  }

  Future<ImageModel?> _loadEnterpriseConcentratorImage() async {
    try {
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      final enterpriseImageResponse = await http.get(
        Uri.parse("$concentratorUrl/Images/Enterprise$enterpriseId/Logo.png"),
      );

      return ImageModel(
        pluOrEan: "",
        image: enterpriseImageResponse.bodyBytes,
        keyIsEan: false,
        isEnterpriseImage: true,
      );
    } catch (e) {
      return null;
    }
  }
}
