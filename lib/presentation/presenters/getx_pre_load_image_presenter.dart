import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class GetxPreLoadImagePresenter extends GetxController
    implements PreLoadImagePresenter {
  GetxPreLoadImagePresenter();

  final List<PreLoadImageEntity> _imageUrls = [];
  @override
  List<PreLoadImageEntity> get imagesUrls => _imageUrls;

  @override
  void updateImagesUrls(MenuPresenter menuPresenter) {
    _imageUrls.clear();

    for (var e in menuPresenter.loadedMenu) {
      for (var products in e.values) {
        for (var product in products) {
          _imageUrls
              .add(PreLoadImageModel.fromProductsViewModel(product).toEntity());
        }
      }
    }
  }
}
