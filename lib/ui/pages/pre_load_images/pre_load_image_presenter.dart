import '../../../domain/entities/entities.dart';
import '../../../ui/pages/menus/menus.dart';

abstract class PreLoadImagePresenter {
  List<PreLoadImageEntity> get imagesUrls;

  void updateImagesUrls(MenuPresenter menuPresenter);
}
