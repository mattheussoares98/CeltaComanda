import 'package:clean_celta_mobile/main/factories/pages/covenant/customer_validation_factory.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../factories.dart';

PaymentPresenter makeGetxPaymentPresenter() => GetxPaymentPresenter(
      pay: makeRedePay(),
      commandInformations: makeRemoteCommandInformations(),
      finishSaleRequestConcentrador: makeRemoteFinishSaleRequestConcentrador(),
      navigateTo: makeNavigateTo(),
      checkPasswordByCustomerCode: makeRemoteCheckPasswordByCustomerCode(),
      covenantLimit: makeRemoteAuthorizeCovenantLimitUseByCode(),
      loadCustomer: makeRemoteLoadCustomer(),
      updateSaleRequest: makeRemoteUpdateSaleRequest(),
      validation: makeCustomerValidation(),
      concInsertSaleMovement: makeRemoteConcInsertSaleMovement(),
      generateXmlForNfce: makeLocalGenerateXmlForNfce(),
      sendSaleMovementAsNfce: makeBsSendSaleMovementAsNfce(),
      couponFiscalNumber: makeLocalCouponFiscalNumber(),
      loadUseUrlSatSharing: makeLocalLoadUseUrlSatSharing(),
      deleteSaleRequest: makeConcDeleteSaleRequest(),
    );
