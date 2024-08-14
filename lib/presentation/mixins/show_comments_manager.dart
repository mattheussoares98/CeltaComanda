import 'package:get/get.dart';

mixin ShowCommentsManager on GetxController {
  final _showComments = false.obs;
  bool get showCommentsValue => _showComments.value;
  Stream<bool> get showCommentsStream => _showComments.stream;
  set showComments(bool value) => _showComments.value = value;
}
