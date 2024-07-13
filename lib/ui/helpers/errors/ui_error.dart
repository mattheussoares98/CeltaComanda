import '../helpers.dart';

enum UIError {
  accessDenied,
  addComment,
  barcodeNotRead,
  commandNotAvailable,
  emailInUse,
  enterpriseOrUrlNotFound,
  invalidCombox,
  invalidCredentials,
  invalidCredentialsOrAccessDenied,
  invalidField,
  obligatoryFixedCommandNumber,
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
      case UIError.obligatoryFixedCommandNumber:
        return R.string.msgObligatoryFixedCommandNumber;
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
