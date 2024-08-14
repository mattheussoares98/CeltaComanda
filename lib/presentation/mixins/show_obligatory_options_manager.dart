import 'package:get/get.dart';

mixin ShowObligatoryOptionsManager on GetxController {
  final _showObligatoryOptions = false.obs;
  bool get showObligatoryOptionValue => _showObligatoryOptions.value;
  Stream<bool> get showObligatoryOptionsStream => _showObligatoryOptions.stream;
  set showObligatoryOptions(bool value) => _showObligatoryOptions.value = value;
}
