import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/builders/builders.dart';
import '../../pages/pages.dart';

class CachedImage extends StatefulWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  const CachedImage({
    required this.ean,
    required this.plu,
    required this.height,
    required this.width,
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

    if (indexOfProduct == -1) {
      return _defaultImage(menuPresenter);
    } else {
      return Image.memory(
        menuPresenter.downloadedImages[indexOfProduct].image,
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    }
  }

  Widget _defaultImage(MenuPresenter menuPresenter) {
    final indexOfEnterpriseImage =
        menuPresenter.downloadedImages.indexWhere((e) => e.isEnterpriseImage);

    if (indexOfEnterpriseImage == -1) {
      return Image.asset(
        "lib/ui/assets/images/imageNotFound.png",
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    } else {
      return Image.memory(
        menuPresenter.downloadedImages[indexOfEnterpriseImage].image,
        height: widget.height,
        width: widget.width,
        fit: EnterpriseBuilder.entity?.zoomImage == true
            ? BoxFit.fitWidth
            : BoxFit.contain,
      );
    }
  }
}
