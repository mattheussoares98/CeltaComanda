import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
    final enterpriseName = EnterpriseBuilder.entity?.enterpriseName;

    try {
      var localImages = await _getLocalImages();

      if (localImages.any((element) =>
          element.enterpriseName == null || element.imagePath.isEmpty)) {
        localImages = await _updateEnterpriseNullProperty(localImages);
      }

      List<String> imagesToDownload = await _getMissingImages(localImages);

      if (getLocalImages && imagesToDownload.isEmpty) {
        final enterpriseImages = localImages
            .where((e) => e.enterpriseName == enterpriseName)
            .toList();
        debugPrint(
            "All local images: ${localImages.length}\nAll enterprise images: ${enterpriseImages.length}");

        return enterpriseImages;
      }

      final filteredLocalImages =
          localImages.where((e) => e.enterpriseName == enterpriseName).toList();
      final updatedSet = updatedImages.toSet(); // Remove duplicatas
      if (updatedSet.isNotEmpty && filteredLocalImages.length > 1) {
        debugPrint("${updatedSet.length} images to update");

        imagesToDownload.addAll(updatedSet);
      }

      return await _getImages(
        localImages: localImages,
        imagesToDownload: imagesToDownload,
      );
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.unexpected:
          //só cai aqui se tentar obter os plus que tem imagem
          debugPrint("Returning local images");
          return (await _getLocalImages())
              .where((e) => e.enterpriseName == enterpriseName)
              .toList();

        default:
          rethrow;
      }
    }
  }

  Future<List<String>> _getPlusWithImages() async {
    try {
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
        url: "$concentratorUrl/api/APIImport/GetImages",
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );
      return List<String>.from(response); // mais direto
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<List<ImageModel>> _downloadImages(List<String> imagesNames) async {
    final images = <ImageModel>[];
    final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
    final enterpriseImage = await _loadEnterpriseConcentratorImage();

    if (enterpriseImage != null) {
      images.add(enterpriseImage);
    }

    final client = http.Client();
    try {
      debugPrint("Downloading ${imagesNames.toSet().length} images");

      for (final pluOrEanPng in imagesNames.toSet()) {
        try {
          final maxSizeInBytes = 1 * 1024 * 1024;
          final url = "$concentratorUrl/Images/$pluOrEanPng";
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
            onDone: () async {
              if (!completer.isCompleted) {
                final imagePath = await _getImagePath(pluOrEanPng);

                final image = ImageModel(
                  pluOrEan: pluOrEanPng,
                  image: Uint8List.fromList(buffer),
                  keyIsEan: pluOrEanPng.length > 11,
                  isEnterpriseImage: false,
                  enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
                  imagePath: imagePath,
                );

                images.add(image);
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

    for (var image in images) {
      await _saveImageToDevice(image);
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

      final path = await _getImagePath("Logo.png");
      return ImageModel(
        pluOrEan: "",
        image: enterpriseImageResponse.bodyBytes,
        keyIsEan: false,
        isEnterpriseImage: true,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
        imagePath: path,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<ImageModel>> _getImages({
    required List<ImageModel> localImages,
    required List<String> imagesToDownload,
  }) async {
    try {
      final newImages = await _downloadImages(imagesToDownload);
      var allImages = [...localImages];

      for (var updatedImage in newImages) {
        int indexInLocalImages = localImages.indexWhere((e) =>
            e.pluOrEan == updatedImage.pluOrEan &&
            e.enterpriseName == updatedImage.enterpriseName);

        if (indexInLocalImages != -1) {
          allImages[indexInLocalImages] = updatedImage;
        } else {
          allImages.add(updatedImage);
        }
      }

      return allImages
          .where((e) =>
              e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ImageModel>> _updateEnterpriseNullProperty(
    List<ImageModel> localImages,
  ) async {
    try {
      debugPrint(
          "updating images because has null enterprise name property...");

      final updated =
          localImages.map((e) => ImageModel.fromJson(e.toJson())).toList();
      //in .toJson, add the enterprise name property

      for (var image in updated) {
        await _saveImageToDevice(image);
      }

      return updated;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> _getMissingImages(List<ImageModel> localImages) async {
    try {
      final filteredLocalImages = localImages
          .where((e) =>
              e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName)
          .toList();
      final plusWithImages = await _getPlusWithImages();

      if (plusWithImages.length > filteredLocalImages.length - 1) {
        final missingImages = plusWithImages
            .where(
              (ean) => !filteredLocalImages.any(
                (local) => local.pluOrEan == ean,
              ),
            )
            .toList();

        debugPrint("missing: ${missingImages.length} images");
        return missingImages;
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ImageModel>> _getLocalImages() async {
    try {
      final localImagesJson = await hiveStorage.get(CacheKeys.images.name);

      if (localImagesJson != null) {
        List<ImageModel> localImages = (localImagesJson as List)
            .map((e) => ImageModel.fromJson(e))
            .toList();

        //save all images in device, instead of hive
        for (var image in localImages) {
          await _saveImageToDevice(image);
        }
        //delete all images in hive
        await hiveStorage.delete(CacheKeys.images.name);

        return localImages;
      } else {
        return await _getImagesFromDevice();
      }
    } catch (e) {
      rethrow;
    }
  }
}

Future<void> _saveImageToDevice(ImageModel image) async {
  final file = File(
    await _getImagePath(
      image.isEnterpriseImage ? "Logo.png" : image.pluOrEan,
      enterpriseName:
          image.enterpriseName ?? EnterpriseBuilder.entity?.enterpriseName,
    ),
  );

  await file.parent.create(recursive: true);

  await file.writeAsBytes(image.image!, flush: true);
}

Future<String> _getImagePath(
  String pluOrEanPng, {
  String? enterpriseName,
}) async {
  late Directory directory;
  if (Platform.isWindows) {
    final userProfile = Platform.environment['USERPROFILE'];
    directory = Directory('$userProfile\\Documents');
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  final separator = Platform.pathSeparator;

  return '${directory.path}${Platform.pathSeparator}images$separator$enterpriseName$separator$pluOrEanPng';
}

Future<List<ImageModel>> _getImagesFromDevice() async {
  final rootDirectory = await getApplicationDocumentsDirectory();

  final correctDirectory = Directory(
      '${rootDirectory.path}${Platform.pathSeparator}images${Platform.pathSeparator}${EnterpriseBuilder.entity?.enterpriseName}');

  if (!correctDirectory.existsSync()) {
    correctDirectory.createSync(recursive: true);
  }

  final files = correctDirectory.listSync();

  List<ImageModel> images = [];

  for (final file in files) {
    if (file is File && file.path.toLowerCase().endsWith('.png')) {
      images.add(
        ImageModel(
          pluOrEan: _getPluEanFromPath(file.path),
          image: null,
          keyIsEan: false, // ajuste se precisar
          isEnterpriseImage: file.path.contains("Logo"), // ajuste se precisar
          enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
          imagePath: file.path,
        ),
      );
    }
  }

  return images;
}

String _getPluEanFromPath(String path) {
  final regex = RegExp(r'([^\\/]+)\.png$', caseSensitive: false);
  final match = regex.firstMatch(path);
  if (match != null) {
    return "${match.group(1)!}.png";
  } else {
    throw Exception('pluOrEan not found in path: $path');
  }
}
