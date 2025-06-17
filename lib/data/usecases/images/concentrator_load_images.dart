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
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class ConcentratorLoadImages with ErrorHandling implements LoadImages {
  final HiveStorage hiveStorage;
  final HttpClient httpClient;

  ConcentratorLoadImages({
    required this.hiveStorage,
    required this.httpClient,
  });

  String get separator => Platform.pathSeparator;

  @override
  Future<List<ImageModel>> load({
    required bool getLocalImages,
    required List<String> updatedImages,
  }) async {
    final enterpriseName = EnterpriseBuilder.entity?.enterpriseName;

    try {
      var localImages = await _getLocalImages();
      final plusWithImages = await _getPlusWithImages();

      List<String> imagesToDownload = await _getMissingImages(
        localImages,
        plusWithImages,
      );

      await deleteNotExistedImages(localImages, plusWithImages);

      if (getLocalImages && imagesToDownload.isEmpty) {
        final enterpriseImages = localImages
            .where((e) => e.enterpriseName == enterpriseName)
            .toList();
        debugPrint("Enterprise local images: ${localImages.length}");

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

  Future<void> deleteNotExistedImages(
    List<ImageModel> localImages,
    List<String> plusWithImages,
  ) async {
    await hiveStorage.delete(CacheKeys.images.name);

    final oldEnterpriseImage = localImages
        .where((e) =>
            e.isLogoImage && !e.imagePath.toLowerCase().contains("enterprise"))
        .toList();

    if (oldEnterpriseImage.isNotEmpty) {
      await File(oldEnterpriseImage.first.imagePath).delete();
    }

    final removedImagesInConcentrator = localImages
        .where((e) => !plusWithImages.any((x) => e.imagePath
            .toLowerCase()
            .contains(x
                .toLowerCase()
                .replaceAll('/', separator)
                .replaceAll("\\", separator))))
        .toList();

    for (var removedImage in removedImagesInConcentrator) {
      final file = File(removedImage.imagePath);

      localImages.remove(removedImage);
      if (file.existsSync()) {
        await file.delete();
        debugPrint("removed image: ${removedImage.imagePath}");
      }
    }
  }

  Future<List<String>> _getPlusWithImages() async {
    try {
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
        url:
            "$concentratorUrl/api/APIImport/GetImages?enterpriseId=${EnterpriseBuilder.entity?.enterpriseId}",
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );
      return List<String>.from(response); // mais direto
    } catch (e) {
      treatError(e);
    }
  }

  Future<List<ImageModel>> _downloadImages(List<String> imagesNames) async {
    final images = <ImageModel>[];
    final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;

    final client = http.Client();
    try {
      debugPrint("Downloading ${imagesNames.toSet().length} images");

      for (final imageName in imagesNames.toSet()) {
        try {
          final maxSizeInBytes = 1 * 1024 * 1024;
          final url = "$concentratorUrl/Images/$imageName";
          final request = http.Request('GET', Uri.parse(url));
          final response = await client.send(request);

          if (response.statusCode != 200) {
            debugPrint(
                "Image not found or server error ${response.statusCode}: $url");
            continue;
          }

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
                final imagePath = await _getImagePath() + imageName;
                final bytes = Uint8List.fromList(buffer);
                final file = File(imagePath);

                final image = ImageModel(
                  pluOrEan: imageName,
                  image: bytes,
                  file: file,
                  keyIsEan: imageName.length > 11,
                  isLogoImage: imageName.toLowerCase().contains("logo"),
                  enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
                  imagePath: imagePath
                      .replaceAll('/', separator)
                      .replaceAll("\\", separator),
                  isMarketingImage: imageName.toLowerCase().contains("market"),
                  uniqueId: DateTime.now().millisecondsSinceEpoch.toString(),
                );

                images.add(image);
                _saveImageToDevice(image);
                completer.complete();
              }
            },
            onError: (error) {
              if (!completer.isCompleted) completer.completeError(error);
            },
            cancelOnError: false,
          );

          await completer.future.timeout(Duration(seconds: 5));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    } finally {
      client.close();
    }

    return images;
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
            e.pluOrEan.toLowerCase() == updatedImage.pluOrEan.toLowerCase() &&
            e.enterpriseName?.toLowerCase() ==
                updatedImage.enterpriseName?.toLowerCase());

        if (indexInLocalImages != -1) {
          allImages.removeAt(indexInLocalImages);
          allImages.add(updatedImage);
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

  Future<List<String>> _getMissingImages(
    List<ImageModel> localImages,
    List<String> plusWithImages,
  ) async {
    try {
      final missingImages = plusWithImages.where((e) {
        final path = e.replaceAll('/', separator).replaceAll("\\", separator);
        return !localImages
            .any((x) => x.imagePath.toLowerCase().contains(path.toLowerCase()));
      }).toList();

      debugPrint("missing: ${missingImages.length} images");
      return missingImages.toSet().toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getImagePath() async {
    late Directory directory;

    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      directory = Directory('$userProfile$separator' "Documents");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final enterpriseName = EnterpriseBuilder.entity?.enterpriseName;

    return '${directory.path}${separator}images$separator$enterpriseName$separator';
  }

  Future<void> _saveImageToDevice(ImageModel image) async {
    final file = File(image.imagePath);

    try {
      if (file.existsSync()) {
        debugPrint("Deleted image");
        await file.delete();
      }
      await file.parent.create(recursive: true);
      await file.writeAsBytes(image.image!, flush: true);
      debugPrint("Saved image");
    } catch (e) {
      debugPrint("Erro ao salvar imagem: ${file.path} - $e");
    }
  }

  Future<List<ImageModel>> _getLocalImages() async {
    final correctDirectory = Directory(await _getImagePath());

    if (!correctDirectory.existsSync()) {
      correctDirectory.createSync(recursive: true);
    }

    final files = correctDirectory.listSync(recursive: true, followLinks: true);

    List<ImageModel> images = [];

    try {
      for (final file in files) {
        final pluOrEan = _getPluEanFromPath(file.path);

        if (file is File) {
          final newBytes =
              Uint8List.fromList(await File(file.path).readAsBytes());

          images.add(
            ImageModel(
              pluOrEan: pluOrEan,
              image: newBytes,
              file: file,
              keyIsEan: !pluOrEan.contains("-"),
              isLogoImage: file.path.toLowerCase().contains("logo"),
              enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
              imagePath: file.path,
              isMarketingImage: file.path.toLowerCase().contains("market"),
              uniqueId: DateTime.now().millisecondsSinceEpoch.toString(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return images;
  }

  String _getPluEanFromPath(String path) {
    final regex = RegExp(r'([^\\/]+)\.(png|jpg)$', caseSensitive: false);
    final match = regex.firstMatch(path);
    if (match != null) {
      final name = match.group(1)!;
      final extension = match.group(2)!.toLowerCase(); // normalize to lowercase
      return "$name.$extension";
    } else {
      return "";
    }
  }
}
