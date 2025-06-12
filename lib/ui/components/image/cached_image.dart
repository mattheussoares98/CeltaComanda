import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/builders/builders.dart';
import '../../pages/pages.dart';

class CachedImage extends StatefulWidget {
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
  CachedImageState createState() => CachedImageState();
}

class CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    final indexOfProduct = menuPresenter.downloadedImages.indexWhere((e) {
      if (e.keyIsEan) {
        return e.pluOrEan.toLowerCase() ==
            "${widget.ean ?? ""}.PNG".toLowerCase();
      } else {
        return e.pluOrEan.toLowerCase() == "${widget.plu}.PNG".toLowerCase();
      }
    });

    if (indexOfProduct == -1 && widget.imagePath == null) {
      return _defaultImage(menuPresenter);
    } else if (indexOfProduct != -1 &&
        menuPresenter.downloadedImages[indexOfProduct].image != null) {
      final image = menuPresenter.downloadedImages[indexOfProduct];
      // if (image.pluOrEan.toLowerCase().contains("11039")) {
      //   debugPrint("Combo dia dos namorados da base de teste");
      // }

      return Image.memory(
        image.image!,
        key: Key(image.uniqueId),
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true &&
                widget.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else {
      return Image.file(
        File(
          widget.imagePath ??
              menuPresenter.downloadedImages[indexOfProduct].imagePath,
        ),
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true &&
                widget.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    }
  }

  Widget _defaultImage(MenuPresenter menuPresenter) {
    final indexOfEnterpriseImage = menuPresenter.downloadedImages
        .indexWhere((e) => e.isLogoImage && File(e.imagePath).existsSync());

    if (indexOfEnterpriseImage == -1) {
      return Image.asset(
        "lib/ui/assets/images/imageNotFound.png",
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true &&
                widget.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else if (menuPresenter.downloadedImages[indexOfEnterpriseImage].image !=
        null) {
      return Image.memory(
        menuPresenter.downloadedImages[indexOfEnterpriseImage].image!,
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true &&
                widget.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else {
      return Image.file(
        File(
          menuPresenter.downloadedImages[indexOfEnterpriseImage].imagePath,
        ),
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true &&
                widget.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    }
  }
}
