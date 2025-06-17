import 'package:equatable/equatable.dart';

import '../helpers.dart';

class UIError extends Equatable {
  final String description;
  const UIError._(this.description);
  @override
  String toString() => description;
  @override
  List<Object?> get props => [description];

  factory UIError.custom(String description) => UIError._(description);

  static final accessDenied = UIError._(R.string.accessDenied);
  static final addComment = UIError._(R.string.addCommentError);
  static final barcodeNotRead = UIError._(R.string.msgBarcodeNotRead);
  static final blockedCommand = UIError._(R.string.msgCommandBlocked);
  static final cantSendServiceChargeProduct =
      UIError._(R.string.msgCantSendServiceChargeProduct);
  static final commandAlreadyPaid = UIError._(R.string.msgCommandAlreadyPaid);
  static final commandNotAvailable = UIError._(R.string.commandNotAvailable);
  static final commandNumberObligatory =
      UIError._(R.string.msgObligatoryFixedCommandNumber);
  static final dontHaveUnusedPdvs = UIError._(R.string.msgDontHaveUnusedPdvs);
  static final emailInUse = UIError._(R.string.msgEmailInUse);
  static final emptySales = UIError._(R.string.emptySales);
  static final enterpriseOrUrlNotFound =
      UIError._(R.string.enterpriseOrUrlNotFound);
  static final invalidCommandNumber =
      UIError._(R.string.msgInvalidCommandNumber);
  static final invalidCombox = UIError._(R.string.msgInvalidCombox);
  static final invalidCredentials = UIError._(R.string.msgInvalidCredentials);
  static final invalidCredentialsOrAccessDenied =
      UIError._(R.string.msgInvalidCredentialsOrAccessDenied);
  static final liquidadeCommandError =
      UIError._(R.string.msgLiquidadeCommandError);
  static final maximumQuantityAchieved =
      UIError._(R.string.msgMaximumQuantityAchieved);
  static final newCommandMustBeEmpty =
      UIError._(R.string.msgNewCommandMustBeEmpty);
  static final notFound = UIError._(R.string.msgNotFound);
  static final obligatoryFixedCommandNumber =
      UIError._(R.string.msgObligatoryFixedCommandNumber);
  static final oldCommandIsEmpty = UIError._(R.string.msgOldCommandIsEmpty);
  static final paymentCanceled = UIError._(R.string.msgPaymentCanceled);
  static final paymentDeclined = UIError._(R.string.msgPaymentDeclined);
  static final paymentPendant = UIError._(R.string.msgPaymentPendant);
  static final paymentUnexpectedError =
      UIError._(R.string.msgPaymentUnexpectedError);
  static final paymentFailed = UIError._(R.string.msgPaymentFailed);
  static final productNotFound = UIError._(R.string.msgProductNotFound);
  static final requiredField = UIError._(R.string.msgRequiredField);
  static final invalidField = UIError._(R.string.msgInvalidField);
  static final sameCommand = UIError._(R.string.msgSameCommand);
  static final shortField = UIError._(R.string.msgVeryShortField);
  static final selectCustomer = UIError._(R.string.msgSelectCustomer);
  static final selectProducts = UIError._(R.string.msgSelectProducts);
  static final unexpected = UIError._(R.string.msgUnexpectedError);
}
