import '../helpers.dart';

enum UIError {
  accessDenied,
  addComment,
  barcodeNotRead,
  blockedCommand,
  commandAlreadyPaid,
  commandNotAvailable,
  emailInUse,
  enterpriseOrUrlNotFound,
  invalidCombox,
  invalidCredentials,
  invalidCredentialsOrAccessDenied,
  invalidField,
  liquidadeCommandError,
  maximumQuantityAchieved,
  obligatoryFixedCommandNumber,
  paymentCanceled,
  paymentDeclined,
  paymentUnexpectedError,
  paymentFailed,
  productNotFound,
  requiredField,
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
      case UIError.commandAlreadyPaid:
        return R.string.msgCommandAlreadyPaid;
      case UIError.commandNotAvailable:
        return R.string.commandNotAvailable;
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
      case UIError.obligatoryFixedCommandNumber:
        return R.string.msgObligatoryFixedCommandNumber;
      case UIError.paymentCanceled:
        return R.string.msgPaymentCanceled;
      case UIError.paymentDeclined:
        return R.string.msgPaymentDeclined;
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
      default:
        return R.string.msgUnexpectedError;
    }
  }
}
