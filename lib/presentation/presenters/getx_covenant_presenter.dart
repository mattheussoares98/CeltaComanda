import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCovenantPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CovenantPresenter {
  final LoadCustomer loadCustomer;
  GetxCovenantPresenter({
    required this.loadCustomer,
  });

  @override
  Future<void> getCustomer(String value) async {
    mainError = null;
    isLoading = true;
    try {
      int? valueInInt = int.tryParse(value);

      if (valueInInt == null) {
        await loadCustomer.load(
          value: value,
          searchTypeInt: 3,
        );
      } else {
        
      }
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode
    } catch (e) {
      e;
    } finally {
      isLoading = false;
    }
  }
}
