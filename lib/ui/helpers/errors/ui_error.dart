import '../helpers.dart';

enum UIError {
  accessDenied,
  addComment,
  barcodeNotRead,
  blockedCommand,
  cantSendServiceChargeProduct,
  commandAlreadyPaid,
  commandNotAvailable,
  commandNumberObligatory,
  dontHaveUnusedPdvs,
  emailInUse,
  enterpriseOrUrlNotFound,
  invalidCombox,
  invalidCredentials,
  invalidCredentialsOrAccessDenied,
  invalidField,
  liquidadeCommandError,
  maximumQuantityAchieved,
  newCommandMustBeEmpty,
  notFound,
  obligatoryFixedCommandNumber,
  oldCommandIsEmpty,
  paymentCanceled,
  paymentDeclined,
  paymentPendant,
  paymentUnexpectedError,
  paymentFailed,
  productNotFound,
  requiredField,
  selectProducts,
  shortField,
  unexpected,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.accessDenied:
        return R.string.accessDenied;
      case UIError.addComment:
        return R.string.addCommentError;
      case UIError.barcodeNotRead:
        return R.string.msgBarcodeNotRead;
      case UIError.blockedCommand:
        return R.string.msgCommandBlocked;
      case UIError.cantSendServiceChargeProduct:
        return R.string.msgCantSendServiceChargeProduct;
      case UIError.commandAlreadyPaid:
        return R.string.msgCommandAlreadyPaid;
      case UIError.commandNotAvailable:
        return R.string.commandNotAvailable;
      case UIError.commandNumberObligatory:
        return R.string.msgObligatoryFixedCommandNumber;
      case UIError.dontHaveUnusedPdvs:
        return R.string.msgDontHaveUnusedPdvs;
      case UIError.emailInUse:
        return R.string.msgEmailInUse;
      case UIError.enterpriseOrUrlNotFound:
        return R.string.enterpriseOrUrlNotFound;
      case UIError.invalidCombox:
        return R.string.msgInvalidCombox;
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
      case UIError.invalidCredentialsOrAccessDenied:
        return R.string.msgInvalidCredentialsOrAccessDenied;
      case UIError.liquidadeCommandError:
        return R.string.msgLiquidadeCommandError;
      case UIError.maximumQuantityAchieved:
        return R.string.msgMaximumQuantityAchieved;
      case UIError.newCommandMustBeEmpty:
        return R.string.msgNewCommandMustBeEmpty;
      case UIError.notFound:
        return R.string.msgNotFound;
      case UIError.obligatoryFixedCommandNumber:
        return R.string.msgObligatoryFixedCommandNumber;
      case UIError.oldCommandIsEmpty:
        return R.string.msgOldCommandIsEmpty;
      case UIError.paymentCanceled:
        return R.string.msgPaymentCanceled;
      case UIError.paymentDeclined:
        return R.string.msgPaymentDeclined;
      case UIError.paymentPendant:
        return R.string.msgPaymentPendant;
      case UIError.paymentUnexpectedError:
        return R.string.msgPaymentUnexpectedError;
      case UIError.paymentFailed:
        return R.string.msgPaymentFailed;
      case UIError.productNotFound:
        return R.string.msgProductNotFound;
      case UIError.requiredField:
        return R.string.msgRequiredField;
      case UIError.invalidField:
        return R.string.msgInvalidField;
      case UIError.shortField:
        return R.string.msgVeryShortField;
      case UIError.selectProducts:
        return R.string.msgSelectProducts;
      default:
        return R.string.msgUnexpectedError;
    }
  }
}
