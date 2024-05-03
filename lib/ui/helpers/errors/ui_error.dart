import '../helpers.dart';

enum UIError {
  accessDenied,
  addComment,
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
      case UIError.accessDenied:
        return R.string.accessDenied;
      case UIError.addComment:
        return R.string.addCommentError;
      case UIError.commandNotAvailable:
        return R.string.commandNotAvailable;
      case UIError.emailInUse:
        return R.string.msgEmailInUse;
      case UIError.enterpriseOrUrlNotFound:
        return R.string.enterpriseOrUrlNotFound;
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
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
