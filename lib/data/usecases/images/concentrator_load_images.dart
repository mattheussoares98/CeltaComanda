import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

  @override
  Future<List<ImageModel>> load({
    required bool getLocalImages,
    required List<String> updatedImages,
  }) async {
    try {
      final enterpriseName = EnterpriseBuilder.entity?.enterpriseName;
      final localImagesJson = await hiveStorage.get(CacheKeys.images.name);
      var localImages = localImagesJson == null
          ? <ImageModel>[]
          : (localImagesJson as List)
              .map((e) => ImageModel.fromJson(e))
              .toList();

      final plusAndEans = await _getPlusAndEansThatContainsImages();
      final filteredLocalImages =
          localImages.where((e) => e.enterpriseName == enterpriseName).toList();

      final localImagesLength = filteredLocalImages.length;

      final updatedSet = {...updatedImages}; // Remove duplicatas

      if (plusAndEans.length > localImagesLength - 1 && localImagesLength > 0) {
        debugPrint("Downloading only missing images");

        final missingImages = plusAndEans
            .where((ean) => !filteredLocalImages.any(
                  (local) => local.pluOrEan == ean,
                ))
            .toList();

        return await _mergedOldAndNewImages(
          localImages: localImages,
          updatedImages: [...missingImages, ...updatedSet],
        );
      }

      if (getLocalImages) {
        debugPrint("Getting local images");

        if (localImages.any((element) => element.enterpriseName == null)) {
          debugPrint(
              "has null enterprise name property in local image models, updating....");

          localImages =
              localImages.map((e) => ImageModel.fromJson(e.toJson())).toList();
          //in .toJson, add the enterprise name property

          await hiveStorage.put(
            CacheKeys.images.name,
            localImages.map((e) => e.toJson()).toList(),
          );
          return localImages
              .where((e) => e.enterpriseName == enterpriseName)
              .toList();
        }
        return filteredLocalImages;
      }

      if (updatedSet.isNotEmpty && filteredLocalImages.length > 1) {
        debugPrint("Updating ${updatedSet.length} images");
        return await _mergedOldAndNewImages(
          localImages: localImages,
          updatedImages: updatedSet.toList(),
        );
      }

      debugPrint("Downloading all images");
      return (await _downloadAllImages(plusAndEans))
          .where((e) => e.enterpriseName == enterpriseName)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> _getPlusAndEansThatContainsImages() async {
    try {
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
        url: "$concentratorUrl/api/APIImport/GetImages",
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );
      return List<String>.from(response); // mais direto
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ImageModel>> _downloadAllImages(
    List<String> plusAndEansThatContainsImagesInConcentrator,
  ) async {
    try {
      final localImagesJson = await hiveStorage.get(CacheKeys.images.name);
      var localImages = localImagesJson == null
          ? <ImageModel>[]
          : (localImagesJson as List)
              .map((e) => ImageModel.fromJson(e))
              .toList();

      final loadedImages = await _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );

      await hiveStorage.put(
        CacheKeys.images.name,
        [
          ...loadedImages.map((e) => e.toJson()),
          ...localImages.map((e) => e.toJson()),
        ],
      );
      return loadedImages;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<ImageModel>> _loadConcentratorImages(
      List<String> imagesNames) async {
    final images = <ImageModel>[];
    final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
    final enterpriseImage = await _loadEnterpriseConcentratorImage();

    if (enterpriseImage != null) images.add(enterpriseImage);

    final client = http.Client();
    try {
      for (final pluOrEan in imagesNames.toSet()) {
        try {
          final maxSizeInBytes = 1 * 1024 * 1024;
          final url = "$concentratorUrl/Images/$pluOrEan";
          final request = http.Request('GET', Uri.parse(url));
          final response = await client.send(request);

          final buffer = <int>[];
          final completer = Completer<void>();
          int totalBytes = 0;

          late StreamSubscription<List<int>> subscription;

          subscription = response.stream.listen(
            (data) {
              totalBytes += data.length;
              buffer.addAll(data);

              if (totalBytes > maxSizeInBytes) {
                subscription.cancel();
                completer
                    .completeError('Tamanho máximo da imagem excedido $url');
              }
            },
            onDone: () {
              if (!completer.isCompleted) {
                images.add(ImageModel(
                  pluOrEan: pluOrEan,
                  image: Uint8List.fromList(buffer),
                  keyIsEan: pluOrEan.length > 11,
                  isEnterpriseImage: false,
                  enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
                ));
                completer.complete();
              }
            },
            onError: (error) {
              if (!completer.isCompleted) completer.completeError(error);
            },
            cancelOnError: true,
          );

          await completer.future;
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    } finally {
      client.close();
    }

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
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<ImageModel>> _mergedOldAndNewImages({
    required List<ImageModel> localImages,
    required List<String> updatedImages,
  }) async {
    try {
      final newImages = await _loadConcentratorImages(updatedImages);

      for (var updatedImage in newImages) {
        int indexInLocalImages = localImages.indexWhere((e) =>
            e.pluOrEan == updatedImage.pluOrEan &&
            e.enterpriseName == updatedImage.enterpriseName);

        if (indexInLocalImages != -1) {
          localImages[indexInLocalImages] = updatedImage;
        } else {
          localImages.add(updatedImage);
        }
      }

      await hiveStorage.put(
        CacheKeys.images.name,
        localImages.map((e) => e.toJson()).toList(),
      );

      return localImages;
    } catch (e) {
      rethrow;
    }
  }
}
