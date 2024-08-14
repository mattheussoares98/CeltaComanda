import 'package:get/get.dart';

mixin CanAdvanceIndexManager on GetxController {
  final _canAdvanceIndex = false.obs;
  Stream<bool> get canAdvanceIndexStream => _canAdvanceIndex.stream;
  set canAdvanceIndex(bool value) => _canAdvanceIndex.value = value;
}
