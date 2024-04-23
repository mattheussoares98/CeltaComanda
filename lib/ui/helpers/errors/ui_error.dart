import '../helpers.dart';

enum UIError {
  emailInUse,
  enterpriseOrUrlNotFound,
  invalidField,
  invalidCredentials,
  requiredField,
  unexpected,
  shortField,
  commandNotAvailable,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.shortField:
        return R.string.msgVeryShortField;
      case UIError.requiredField:
        return R.string.msgRequiredField;
      case UIError.invalidField:
        return R.string.msgInvalidField;
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
      case UIError.emailInUse:
        return R.string.msgEmailInUse;
      case UIError.enterpriseOrUrlNotFound:
        return R.string.enterpriseOrUrlNotFound;
      case UIError.commandNotAvailable:
        return R.string.commandNotAvailable;
      default:
        return R.string.msgUnexpectedError;
    }
  }
}
