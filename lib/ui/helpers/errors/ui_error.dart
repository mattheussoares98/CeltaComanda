import '../helpers.dart';

enum UIError {
  accessDenied,
  commandNotAvailable,
  emailInUse,
  enterpriseOrUrlNotFound,
  invalidCredentials,
  invalidField,
  requiredField,
  shortField,
  unexpected,
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
      case UIError.accessDenied:
        return R.string.accessDenied;
      default:
        return R.string.msgUnexpectedError;
    }
  }
}
