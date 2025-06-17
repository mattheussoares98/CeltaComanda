import '../../domain/helpers/helpers.dart';
import '../../infra/helpers/helpers.dart';
import '../../ui/helpers/helpers.dart';

mixin ErrorHandling {
  UIError getUIError(dynamic error) {
    if (error is DomainError) {
      switch (error) {
        case DomainError.accessDenied:
          return UIError.accessDenied;
        case DomainError.addComment:
          return UIError.addComment;
        case DomainError.barcodeNotRead:
          return UIError.barcodeNotRead;
        case DomainError.blockedCommand:
          return UIError.blockedCommand;
        case DomainError.cantSendServiceChargeProduct:
          return UIError.cantSendServiceChargeProduct;
        case DomainError.commandAlreadyPaid:
          return UIError.commandAlreadyPaid;
        case DomainError.commandNotAvailable:
          return UIError.commandNotAvailable;
        case DomainError.commandNumberObligatory:
          return UIError.commandNumberObligatory;
        case DomainError.dontHaveUnusedPdvs:
          return UIError.dontHaveUnusedPdvs;
        case DomainError.enterpriseOrUrlNotFound:
          return UIError.enterpriseOrUrlNotFound;
        case DomainError.emptySales:
          return UIError.emptySales;
        case DomainError.invalidCommandNumber:
          return UIError.invalidCommandNumber;
        case DomainError.invalidCombox:
          return UIError.invalidCombox;
        case DomainError.invalidCredentials:
          return UIError.invalidCredentials;
        case DomainError.invalidCredentialsOrAccessDenied:
          return UIError.invalidCredentialsOrAccessDenied;
        case DomainError.maximumQuantityAchieved:
          return UIError.maximumQuantityAchieved;
        case DomainError.newCommandMustBeEmpty:
          return UIError.newCommandMustBeEmpty;
        case DomainError.notFound:
          return UIError.notFound;
        case DomainError.obligatoryFixedCommandNumber:
          return UIError.obligatoryFixedCommandNumber;
        case DomainError.oldCommandIsEmpty:
          return UIError.oldCommandIsEmpty;
        case DomainError.productNotFound:
          return UIError.productNotFound;
        case DomainError.sameCommand:
          return UIError.sameCommand;
        case DomainError.selectCustomer:
          return UIError.selectCustomer;
        case DomainError.selectProducts:
          return UIError.selectProducts;
        case DomainError.unexpected:
          return UIError.unexpected;
      }
    } else if (error is ApiError) {
      return UIError.custom(error.message);
    } /* else if (error is BsError) {
    //TODO create BsError
      return UIError.custom(error.message);
    } */

    return UIError.unexpected;
  }
}
