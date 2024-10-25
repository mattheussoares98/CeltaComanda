// ignore_for_file: annotate_overrides

import './translation.dart';

class EnUs implements Translation {
  String get msgAuthorizationIsPendant => "Pendant authotization";
  String get msgBarcodeNotRead => 'Barcode not read';
  String get msgBlockedCommand => 'Command blocked';
  String get msgEmailInUse => 'Email already in use';
  String get msgClearCartOnLogout => 'Upon logout, the cart will be cleared!';
  String get msgCloseApplication => 'Close application';
  String get msgCommandAlreadyPaid =>
      'This command already paid but an error was ocurred to liquidate. Liberate or liquidate this command';
  String get msgCommandBlocked => 'This command is blocked';
  String get msgCommandDontHaveOpenValues => 'This command has no open values';
  String get msgCommandDontHaveProducts =>
      "This command has no products inserted";
  String get msgConsultCommandToViewProducts =>
      "Search command to view products";
  String get msgEvaluateFood => 'Rate the food';
  String get msgEvaluateDrink => 'Rate the drink';
  String get msgEvaluateEnvironment => 'Rate the environment';
  String get msgEvaluateService => 'Rate the service';
  String get msgEvaluateCostBenefit => 'Rate the cost-benefit';
  String get msgIfLogoutClearCart => 'If you do logout, the cart was clear';
  String get msgInsertCommandNumber => 'Enter the command number';
  String get msgInvalidCombox =>
      'Select all mandatory products to save the combo';
  String get msgInvalidCredentials => 'Invalid credentials.';
  String get msgInvalidCredentialsOrAccessDenied =>
      'Invalid credentials or user not authorized';
  String get msgInvalidField => 'Invalid field';
  String get msgInvalidNumber => 'Invalid number';
  String get msgLiquidadeCommandError =>
      "One error was ocurred to cancel liquidate the command";
  String get msgLowBatteryChargeDevice =>
      'Charge the device. It is running low on battery';
  String get msgMaximumQuantityAchieved => "Maximum quantity achivied";
  String get msgNotFound => "Value not found";
  String get msgNumberCopiedSuccessfully => "Number copied successfully";
  String get msgObligatoryFixedCommandNumber =>
      'The command number is mandatory';
  String get msgPaymentCanceled => 'Payment canceled';
  String get msgPaymentDeclined => 'Payment declined';
  String get msgPaymentPendant => "Payment pendant";
  String get msgPaymentUnexpectedError =>
      'One error was ocurred in the payment';
  String get msgPaymentEmpty => 'The command has no open values';
  String get msgPaymentFailed => 'Payment failed';
  String get msgPendantAuthorizationNotification =>
      "The authorization is pending of confirmation. If you do this action, the authorization will continue to affect the customer's balance. The ideal is to try to liquidate the command again. Did you want do this action and don't cancel the possibility of liquidation?";
  String get msgProductNotFound => 'The product was not found';
  String get msgRequestSentSuccessfully => 'The request was sent successfully';
  String get msgRequiredField => 'Required field';
  String get msgReleasesCommand => "Command released";
  String get msgSearchCommandToPay => 'Look up a command to make the payment';
  String get msgSelectCommand => 'Select the command';
  String get msgSelectPeopleNumbers => 'Select the number of people';
  String get msgSelectSeller => 'Select the seller';
  String get msgSuccessToCancelProducts => 'Product cancellation allowed';
  String get msgTableNumber => 'Table number';
  String get msgUpdatedTableConfigurationsSuccess =>
      'Configurations updated successfully';
  String get msgUpdatedTableSuccess => "Table number updated successfully";
  String get msgUnexpectedError =>
      'Something went wrong. Please try again later.';
  String get msgUseOnlyWhenIsFixedTableNumber =>
      'This option should only be used when using a fixed tablet per table';
  String get msgVeryShortField => 'Field too short';
  String get msgWantCloseApplication =>
      'Do you really want to close the application?';
  String get msgWantDoLogout => 'Do you really want to log out?';
  String get msgWhenConfirmProductsAreRequestAndSoonIncome =>
      'By confirming, the products will be requested and will be served shortly';
  String get msgWriteCommandNumber => 'Enter the command number';
  String get msgWriteEanOrPlu => 'Enter the EAN or PLU';
  String get msgWriteName => 'Enter your name';
  String get msgWriteOnlyNumbers => 'Enter only numbers';
  String get msgWritePassword => 'Enter the password';
  String get msgWriteTableNumber => 'Enter the table number';
  String get msgWriteThreeNumbers => 'Enter 3 numbers';
  String get msgWriteUserCode => 'Enter the user code';

  String get accessDenied => 'User does not have permission';
  String get advance => 'Advance';
  String get addAccount => 'Create account';
  String get addCommentError => 'An error occurred while adding the comment';
  String get addFlagOrTable => 'Add flag/table number';
  String get addItens => 'Add items';
  String get addMoreItens => 'Add more items';
  String get alwaysUseSameTable => 'Always use the same table';
  String get avaliate => 'Evaluate';
  String get blockCommand => 'Block command';
  String get cart => 'Cart';
  String get call => 'Call';
  String get cancel => 'Cancel';
  String get cashCredit => 'Cash credit';
  String get cellPhone => 'Cell phone';
  String get clearCart => 'Clear cart';
  String get closeApplication => 'Close APP';
  String get close => 'Close';
  String get code => 'Code';
  String get internalcodeNameOrCpf => 'Internal code, name or CPF';
  String get combox => 'Combox';
  String get commandNotAvailable => 'Command not available';
  String get command => 'Command';
  String get commandNumber => 'Command number';
  String get commentsOfProduct => 'Product comments';
  String get comments => 'Comments';
  String get comment => 'Comment';
  String get configurations => 'Configurations';
  String get confirmFlag => 'Confirm flag';
  String get confirmPassword => 'Confirm password';
  String get confirm => 'Confirm';
  String get contactUs => 'Contact us';
  String get costBenefit => 'Cost-benefit';
  String get covenant => 'Covenant';
  String get covenants => 'Covenants';
  String get customer => 'Customer';
  String get debit => 'Debit';
  String get detach => 'Highlights';
  String get doLogout => 'Log out';
  String get doYouWantToAdd => 'Do you want add?';
  String get drink => 'Drink';
  String get eanOrPlu => 'EAN or PLU';
  String get email => 'Email';
  String get emptyCart => 'The cart is empty';
  String get enterprise => 'Enterprise';
  String get enterpriseOrUrlNotFound => 'Enterprise and URL not found';
  String get environment => 'Environment';
  String get exit => 'Exit';
  String get getCustomer => 'Get customer';
  String get insertInCart => 'Add to cart';
  String get insert => 'Insert';
  String get ifWantSelectComments => 'If desired, select comments';
  String get ifWantSelectProducts => 'If desired, select a product';
  String get jump => 'Skip';
  String get liberateCancelProducts => 'Allow item cancellation';
  String get liberateCommand => 'Liberate command';
  String get liquidateCommand => 'Liquidate command';
  String get liquidateCommandSucceeds => 'Command successfully liquidated';
  String get loadMenu => 'Load menu';
  String get login => 'Login';
  String get name => 'Name';
  String get neww => 'New';
  String get no => 'No';
  String get obligatory => 'Mandatory';
  String get obligatoryComments => 'Mandatory comments';
  String get optional => 'Optional';
  String get password => 'Password';
  String get pay => 'Pay';
  String get peopleQuantity => 'Number of people';
  String get per => 'Per';
  String get personalizedCode => 'Personalized code';
  String get price => 'Price';
  String get productsAndComments => 'Products and comments';
  String get promotionWithoutPoints => 'Promotion without points';
  String get quantity => 'Quantity';
  String get quantityAbbreviated => 'Qty';
  String get reload => 'Reload';
  String get removeProduct => 'Remove product';
  String get requested => 'Requested';
  String get requestedAt => 'Requested at';
  String get requestSentSuccessfully => 'The request was sent successfully';
  String get reserved => 'Reserved';
  String get reserveTable => 'Reserve table';
  String get searchDataOfOtherCommandNumber =>
      'Search data of other command number';
  String get searchCommandData => 'Search command data';
  String get searchProduct => 'Search product';
  String get searchType => 'Search type';
  String get selectOneComment => "Select one comment";
  String get selectedProductsAndComments => 'Selected products and comments';
  String get selectPaymentOption => 'Select a payment option';
  String get selectProduct => 'Select a product!';
  String get selectQuantity => 'Enter the quantity';
  String get seller => 'Seller';
  String get sendEvaluation => 'Send evaluation';
  String get sendMessage => 'Send message';
  String get sendRequest => 'Send request';
  String get send => 'Send';
  String get service => 'Service';
  String get serviceCharge => 'Service charge';
  String get subtotal => 'Subtotal';
  String get suggestionCriticalOrPraise => 'Suggestion, criticism, or praise';
  String get support => 'Support';
  String get supportContact => 'Support contact';
  String get surveys => 'Surveys';
  String get surveyResult => 'Survey result';
  String get table => 'Table';
  String get time => 'Time';
  String get total => 'Total';
  String get totalByPerson => 'Total by person';
  String get turnBack => 'Go back';
  String get updateConfigurations => 'Update configurations';
  String get updateMenu => 'Update menu';
  String get updateTableNumberAndPeopleNumbers =>
      'Update table and number of people';
  String get updateTableNumber => "Update table number";
  String get userCode => 'User code';
  String get user => 'User';
  String get url => 'Enterprise or URL';
  String get validateEnterprise => 'Validate enterprise';
  String get voucher => 'Voucher';
  String get wait => 'Please wait...';
  String get wantRemoveRequestedProduct =>
      'Do you really want to remove the product from the requested products?';
  String get yes => "yes";
  String get withoutCovenant => "Without covenant";
}
