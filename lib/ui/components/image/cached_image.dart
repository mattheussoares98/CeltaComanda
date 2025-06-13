import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../../main/builders/builders.dart';
import '../../pages/pages.dart';

class CachedImage extends StatelessWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  final bool zoomImage;
  final String? imagePath;
  const CachedImage({
    required this.ean,
    required this.plu,
    required this.height,
    required this.width,
    required this.imagePath,
    this.zoomImage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    final pathIndex = menuPresenter.downloadedImages
        .indexWhere((e) => e.imagePath == imagePath);

    final productIndex = menuPresenter.downloadedImages.indexWhere((e) =>
        e.pluOrEan.toLowerCase() ==
        "${e.keyIsEan ? ean : plu}.PNG".toLowerCase());

    ImageModel? image;
    if (pathIndex != -1) {
      image = menuPresenter.downloadedImages[pathIndex];
    } else if (productIndex != -1) {
      image = menuPresenter.downloadedImages[productIndex];
    }

    if (image?.image == null) {
      return _defaultImage(menuPresenter);
    }

    return Image.memory(
      image!.image!,
      key: Key(image.uniqueId),
      height: height,
      width: width,
      fit: EnterpriseBuilder.entity?.zoomImage == true && zoomImage == true
          ? BoxFit.fitWidth
          : BoxFit.contain,
    );
  }

  Image _defaultImage(MenuPresenter menuPresenter) {
    final indexOfEnterpriseImage = menuPresenter.downloadedImages
        .indexWhere((e) => e.isLogoImage && File(e.imagePath).existsSync());

    if (indexOfEnterpriseImage == -1) {
      return Image.asset(
        "lib/ui/assets/images/imageNotFound.png",
        height: height,
        width: width,
        fit: EnterpriseBuilder.entity?.zoomImage == true && zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else if (menuPresenter.downloadedImages[indexOfEnterpriseImage].image !=
        null) {
      final image = menuPresenter.downloadedImages[indexOfEnterpriseImage];
      return Image.memory(
        key: Key(image.uniqueId),
        image.image!,
        height: height,
        width: width,
        fit: EnterpriseBuilder.entity?.zoomImage == true && zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else {
      return Image.file(
        File(
          menuPresenter.downloadedImages[indexOfEnterpriseImage].imagePath,
        ),
        height: height,
        width: width,
        fit: EnterpriseBuilder.entity?.zoomImage == true && zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    }
  }
}
