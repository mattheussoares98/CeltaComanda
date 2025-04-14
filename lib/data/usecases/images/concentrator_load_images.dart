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

      List<ImageModel> imagesOfAtualEnterprise = [];

      final plusAndEansThatContainsImages =
          await _getPlusAndEansThatContainsImages();

      if (plusAndEansThatContainsImages.length >
          (localImages.length - 1 /* -1 because enterprise image */)) {
        //all images that are not in localImages, but has in concentrator

        final missingConcentratorImages = plusAndEansThatContainsImages
            .where(
              (ean) => !localImages.any((local) =>
                  local.pluOrEan == ean &&
                  local.enterpriseName ==
                      EnterpriseBuilder.entity?.enterpriseName),
            )
            .toList();

        imagesOfAtualEnterprise = await _mergedOldAndNewImages(
          localImages: localImages,
          updatedImages: [...missingConcentratorImages, ...updatedImages],
        );
      } else if (getLocalImages) {
        imagesOfAtualEnterprise = localImages;
      } else if (updatedImages.isNotEmpty &&
          localImages
              .where((e) =>
                  e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName)
              .isNotEmpty) {
        //TODO fix when do login is trying to download again what already is downloaded
        imagesOfAtualEnterprise = await _mergedOldAndNewImages(
          localImages: localImages,
          updatedImages: updatedImages,
        );
      } else {
        imagesOfAtualEnterprise =
            await reloadAllImages(plusAndEansThatContainsImages);
      }

      return imagesOfAtualEnterprise
          .where((e) =>
              e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName)
          .toList();
    } catch (e) {
      throw DomainError.unexpected;
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

      return (response as List)
          .map<String>((e) => e.toString())
          .toList()
          .cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<List<ImageModel>> reloadAllImages(
    List<String> plusAndEansThatContainsImagesInConcentrator,
  ) async {
    try {
      final localImages = await hiveStorage.get(CacheKeys.images.name);

      final loadedImages = await _loadConcentratorImages(
        plusAndEansThatContainsImagesInConcentrator,
      );

      await hiveStorage.delete(CacheKeys.images.name);
      await hiveStorage.put(
        CacheKeys.images.name,
        [...loadedImages.map((e) => e.toJson()), ...localImages],
      );
      return loadedImages;
    } catch (e) {
      return [];
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

    for (var pluOrEan
        in imagesNames.toSet() /* sometimes duplicate imageNames */) {
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
                enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
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

      await hiveStorage.delete(CacheKeys.images.name);
      await hiveStorage.put(
        CacheKeys.images.name,
        localImages.map((e) => e.toJson()).toList(),
      );

      return localImages;
    } catch (e) {
      return []; //return empty list
    }
  }
}
