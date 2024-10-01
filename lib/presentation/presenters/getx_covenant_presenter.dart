import '../../domain/entities/entities.dart';
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

      List<CustomerEntity>? result;

// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode
      if (valueInInt == null) {
        result = await loadCustomer.load(
          value: value,
          searchTypeInt: 3,
        );
      } else {
        if (valueInInt.toString().length == 11 ||
            valueInInt.toString().length == 14) {
          result = await loadCustomer.load(
            value: value,
            searchTypeInt: 1,
          );
        }
        result ??= await loadCustomer.load(
          value: value,
          searchTypeInt: 2,
        );
        result ??= await loadCustomer.load(
          value: value,
          searchTypeInt: 4,
        );
      }

      print(result);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
