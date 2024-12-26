// ignore_for_file: annotate_overrides

import './translation.dart';

class EnUs implements Translation {
  String get msgAuthorizationIsPendant => "Pendant authotization";
  String get msgAllChildsAreDisabled =>
      "Please, call the waiter to relate this problem\nAll childs are disabled, enable a child";
  String get msgBarcodeNotRead => 'Barcode not read';
  String get msgBlockedCommand => 'Command blocked';
  String get msgCantAddCombox => "Can't add combox here";
  String get msgCantSendServiceChargeProduct =>
      "Can't send service charge product";
  String get msgClearCartOnLogout => 'Upon logout, the cart will be cleared!';
  String get msgClearConfirmedPayments => 'Clear all confirmed payments';
  String get msgCloseApplication => 'Close application';
  String get msgCommandAlreadyPaid =>
      'This command already paid but an error was ocurred to liquidate. Liberate or liquidate this command';
  String get msgCommandBlocked => 'This command is blocked';
  String get msgCommandDontHaveOpenValues => 'This command has no open values';
  String get msgCommandDontHaveProducts =>
      "This command has no products inserted";
  String get msgConfirmClearTotalPaid =>
      "If you exit the page, the paid value will be cleared";
  String get msgConfirmSendProducts => "Do you want confirm send products?";
  String get msgConsultCommandToViewProducts =>
      "Search command to view products";
  String get msgDontHaveUnusedPdvs =>
      "There are no PDVs released for registration";
  String get msgEmailInUse => 'Email already in use';
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
  String get msgNewCommandMustBeEmpty => "The new table must be empty";
  String get msgNewTable => "New table";
  String get msgNotFound => "Value not found";
  String get msgNumberCopiedSuccessfully => "Number copied successfully";
  String get msgObligatoryFixedCommandNumber =>
      'The command number is mandatory';
  String get msgOldCommandIsEmpty => "The old table is empty";
  String get msgOldTable => "Old table";
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
  String get msgSelectDifferentTables => 'Select different tables';
  String get msgSelectPeopleNumbers => 'Select the number of people';
  String get msgSelectProducts => 'Select products';
  String get msgSelectSeller => 'Select the seller';
  String get msgSelectTable => 'Select the tabls';
  String get msgSuccessToCancelProducts => 'Product cancelled';
  String get msgSuccessToUpdateCommandNumberProducts =>
      "The products were sent to the new command";
  String get msgSuccessToUpdateSchedule =>
      'The schedule has been configured successfully';
  String get msgSuccessUpdateMenuInAllDevices =>
      'The menu will be updated in all devices';
  String get msgTableClosedSuccessfully => 'Table closed successfully';
  String get msgTableNumber => 'Table number';
  String get msgUpdatedTableConfigurationsSuccess =>
      'Configurations updated successfully';

  String get msgUpdatedTableSuccess => "Table number updated successfully";
  String get msgUnexpectedError =>
      'Something went wrong. Please try again later.';
  String get msgUseOnlyWhenIsFixedTableNumber =>
      'This option should only be used when using a fixed tablet per table';
  String get msgValidateEnterpriseFirst => "Validate the enterprise first";
  String get msgVeryShortField => 'Field too short';
  String get msgWantCloseApplication =>
      'Do you really want to close the application?';
  String get msgWantCloseTable => "Do you really want close the table?";
  String get msgWantDoLogout => 'Do you really want to log out?';
  String get msgWantUpdateMenuInAllDevices =>
      "Do you want update the menu in all devices?";
  String get msgWhenConfirmProductsAreRequestAndSoonIncome =>
      'By confirming, the products will be requested and will be served shortly';
  String get msgWriteCommandNumber => 'Enter the command number';
  String get msgWriteEanOrPlu => 'Enter the EAN or PLU';
  String get msgWriteName => 'Enter your name';
  String get msgWriteOnlyNumbers => 'Enter only numbers';
  String get msgWritePassword => 'Enter the password';
  String get msgWritePaymentValue => 'Write the payment value';
  String get msgWriteTableNumber => 'Enter the table number';
  String get msgWriteThreeNumbers => 'Enter 3 numbers';
  String get msgWriteUserCode => 'Enter the user code';

  String get accessConfigurations => 'Access configurations';
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
  String get blockTable => 'Block table';
  String get cart => 'Cart';
  String get call => 'Call';
  String get cancel => 'Cancel';
  String get cancelProductsOrRemoveServiceCharge =>
      'Cancel products or remove service charge';
  String get cancelProduct => 'Cancel product';
  String get cashCredit => 'Cash credit';
  String get cellPhone => 'Cell phone';
  String get child => 'Child';
  String get clearCart => 'Clear cart';
  String get closeApplication => 'Close APP';
  String get closeTable => 'Close table';
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
  String get conferenceOfTable => 'Conference of table';
  String get configurations => 'Configurations';
  String get confirmFlag => 'Confirm flag';
  String get confirmPassword => 'Confirm password';
  String get confirmSchedule => 'Confirm schedule';
  String get confirm => 'Confirm';
  String get contactUs => 'Contact us';
  String get costBenefit => 'Cost-benefit';
  String get covenant => 'Covenant';
  String get covenants => 'Covenants';
  String get customer => 'Customer';
  String get dateNotUpdated => 'Date not updated';
  String get debit => 'Debit';
  String get destinyTable => 'Destiny table';
  String get detach => 'Highlights';
  String get developedByCeltaware => 'Developed by Celtaware';
  String get doLogout => 'Log out';
  String get doYouWantToAdd => 'Do you want add?';
  String get drink => 'Drink';
  String get eanOrPlu => 'EAN or PLU';
  String get email => 'Email';
  String get emptyCart => 'The cart is empty';
  String get emptyTable => 'The table is empty';
  String get enableSearchProducts => 'Enable search products';
  String get enterprise => 'Enterprise';
  String get enterpriseOrUrlNotFound => 'Enterprise and URL not found';
  String get environment => 'Environment';
  String get exit => 'Exit';
  String get expansibleGroup => 'Expansible group';
  String get father => 'Father';
  String get friday => 'Friday';
  String get getCustomer => 'Get customer';
  String get insertInCart => 'Add to cart';
  String get insert => 'Insert';
  String get ifWantSelectComments => 'If desired, select comments';
  String get ifWantSelectProducts => 'If desired, select a product';
  String get jump => 'Skip';
  String get liberateCancelProducts => 'Allow item cancellation';
  String get liberateCommand => 'Liberate command';
  String get liberateOrBlockTable => "Liberate or block table";
  String get liberateTable => "Liberate table";
  String get liquidateCommand => 'Liquidate command';
  String get liquidateCommandSucceeds => 'Command successfully liquidated';
  String get loadMenu => 'Load menu';
  String get login => 'Login';
  String get maximumAbbreviated => "Max";
  String get minimumAbbreviated => "Min";
  String get missing => 'Missing';
  String get monday => 'Monday';
  String get name => 'Name';
  String get neww => 'New';
  String get no => 'No';
  String get obligatory => 'Mandatory';
  String get obligatoryComments => 'Mandatory comments';
  String get optional => 'Optional';
  String get originTableIsEmpty => 'Oritin table is empty';
  String get originTable => 'Oritin table';
  String get parameters => 'Parameters';
  String get password => 'Password';
  String get pay => 'Pay';
  String get pdv => 'Pdv';
  String get paymentValue => 'Payment value';
  String get peopleQuantity => 'Number of people';
  String get per => 'Per';
  String get personalizedCode => 'Personalized code';
  String get price => 'Price';
  String get productsAndComments => 'Products and comments';
  String get productsSchedules => 'Products schedules';
  String get products => 'Products';
  String get product => 'Product';
  String get promotionWithoutPoints => 'Promotion without points';
  String get quantity => 'Quantity';
  String get quantityAbbreviated => 'Qty';
  String get register => 'Register';
  String get reload => 'Reload';
  String get removeProduct => 'Remove product';
  String get removeServiceCharge => 'Remove service';
  String get requested => 'Requested';
  String get requestedAt => 'Requested at';
  String get requestSentSuccessfully => 'The request was sent successfully';
  String get reserved => 'Reserved';
  String get reserveTable => 'Reserve table';
  String get sales => "Sales";
  String get saturday => "Saturday";
  String get search => "Search";
  String get searchByPersonalizedCode => "Search by personalized code";
  String get searchDataOfOtherCommandNumber =>
      'Search data of other command number';
  String get searchCommandData => 'Search command data';
  String get searchProduct => 'Search product';
  String get searchType => 'Search type';
  String get selectAll => "Select all";
  String get selectAllProducts => "Select all products";
  String get selectOneComment => "Select one comment";
  String get selectedProductsAndComments => 'Selected products and comments';
  String get selectPaymentOption => 'Select a payment option';
  String get selectPdv => 'Select one PDV';
  String get selectProduct => 'Select a product!';
  String get selectQuantity => 'Enter the quantity';
  String get seller => 'Seller';
  String get sendAllProductsToAnotherTable =>
      'Send ALL products to another table';
  String get sendOneOrMoreProductsToAnotherTable =>
      'Send ONE OR MORE products to another table';
  String get sendEvaluation => 'Send evaluation';
  String get sendMessage => 'Send message';
  String get sendProductsToAnotherTable => 'Send products to another table';
  String get sendRequest => 'Send request';
  String get send => 'Send';
  String get service => 'Service';
  String get serviceCharge => 'Service charge';
  String get serviceChargeAbbreviated => 'Service';
  String get subtotal => 'Subtotal';
  String get suggestionCriticalOrPraise => 'Suggestion, criticism, or praise';
  String get sunday => 'Sunday';
  String get support => 'Support';
  String get supportContact => 'Support contact';
  String get surveys => 'Surveys';
  String get surveyResult => 'Survey result';
  String get table => 'Table';
  String get tableConfigurations => 'Table configurations';
  String get thursday => 'Thursday';
  String get time => 'Time';
  String get total => 'Total';
  String get totalPaid => 'Total paid';
  String get totalByPerson => 'Total by person';
  String get tuesday => 'Tuesday';
  String get turnBack => 'Go back';
  String get unselectAll => 'Unselect all';
  String get unselectAllProducts => 'Unselect all products';
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
  String get wednesday => "Wednesday";
  String get yes => "yes";
  String get withoutCovenant => "Without covenant";
}
