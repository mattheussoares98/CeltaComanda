import 'dart:convert';

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../ui/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxCovenantPresenter sut;
  late HomePresenterSpy homePresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late PaymentPresenterSpy paymentPresenter;

  late LoadCustomerSpy loadCustomer;
  late ValidationSpy validation;
  late FinishSaleRequestConcentradorSpy finishSaleRequestConcentrador;
  late CovenantLimitSpy covenantLimit;
  late UpdateSaleRequestSpy updateSaleRequest;
  late CheckPasswordByCustomerCodeSpy checkPasswordByCustomerCode;

  late List<CustomerEntity> customersEntitys;
  late List<CustomerViewModel> customersViewModel;

  late SoapResponse soapResponse;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadCustomer = LoadCustomerSpy();
    validation = ValidationSpy();
    finishSaleRequestConcentrador = FinishSaleRequestConcentradorSpy();
    covenantLimit = CovenantLimitSpy();
    checkPasswordByCustomerCode = CheckPasswordByCustomerCodeSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    paymentPresenter = PaymentPresenterSpy();
  }

  void initEntitys() {
    EnterpriseBuilder.entity =
        EntityFactory.makeEnterpriseData();
    customersEntitys = EntityFactory.makeCustomersEntitys();
    customersViewModel =
        customersEntitys.map((e) => CustomerViewModel.fromEntity(e)).toList();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(100).toString().padLeft(3, "0");
    soapResponse = SoapResponse(
      response: faker.randomGenerator.string(10),
      responseType: SoapResponseType.success,
    );

    sut = GetxCovenantPresenter(
      loadCustomer: loadCustomer,
      validation: validation,
      covenantLimit: covenantLimit,
      updateSaleRequest: updateSaleRequest,
      checkPasswordByCustomerCode: checkPasswordByCustomerCode,
    );
  }

  void mockSuccess() {
    loadCustomer.mockLoadCustomer(
      SoapResponse(
        response: json.encode(customersEntitys
            .map((e) => CustomerViewModel.fromEntity(e).toJson())
            .toList()),
        responseType: SoapResponseType.success,
      ),
    );
    covenantLimit
        .mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(soapResponse);
    checkPasswordByCustomerCode.mockCheck(soapResponse);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(EntityFactory.makeConcentratorFinaliztionModel());
    registerFallbackValue(
      EntityFactory.makeSaleRequestModel(covenantCode: 1, customerCode: 1),
    );
  });

  group("Get customer", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should emit correct values on not found customer", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      loadCustomer.mockLoadCustomer(
        const SoapResponse(
          response: "response",
          responseType: SoapResponseType.success,
        ),
      );
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test("Should emit correct values on throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadCustomer.mockError();
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: faker.randomGenerator.string(10));
    });
    test(
        "Should call loadCustomer with searchType 3 when cant convert value to int",
        () async {
      final valueToSearch = faker.randomGenerator.string(100);

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 3, //ApproximatedName
        ),
      ).called(1);
    });
    test("Should call loadCustomer with searchType 1 when is CPF", () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 1, //ExactCnpjCpfNumber
        ),
      ).called(1);
    });
    test("Should call loadCustomer with searchType 1 when is CNPJ", () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 1, //ExactCnpjCpfNumber
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 2 when is number and dont is cpf",
        () async {
      loadCustomer.mockLoadCustomer(
        const SoapResponse(
          response: "response",
          responseType: SoapResponseType.error,
        ),
      );

      final valueToSearch = faker.randomGenerator.decimal().toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 2, //ExactCode
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 4 when searchByPersonalizedCode",
        () async {
      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: true,
          showErrorMessageReturnedByBs: (_) {},
          value: valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 4,
        ),
      ).called(1);
    });
    test("Should not get customer if value is empty", () async {
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "");

      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 1,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 2,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 3,
          ));
      verifyNever(() => loadCustomer.load(
            value: "",
            searchTypeInt: 4,
          ));
    });
    test("Should emit correct value on customerViewModelStream", () async {
      expectLater(
          sut.customersViewModelStream,
          emitsInOrder([
            null,
            customersEntitys
                .map((e) => CustomerViewModel.fromEntity(e))
                .toList()
          ]));

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");
    });

    test("Should clear selectedCovenant", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });

      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");

      expect(sut.selectedCovenant, {});
    });
    test("Should clear authorizationPendingModel", () async {
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: "any");

      expect(sut.authorizationPendingModel, null);
    });

    test("Should call validate customer field", () async {
      final searchValue = faker.randomGenerator.string(10);
      await sut.getCustomerByNameCodeOrCpf(
          searchByPersonalizedCode: false,
          showErrorMessageReturnedByBs: (_) {},
          value: searchValue);

      verify(() => validation.validate(
            field: "customer",
            input: {"customer": searchValue},
          )).called(1);
    });
  });

  group("Validate customer field", () {
    test("Should emit correct values if is valid", () {
      expectLater(sut.customerErrorStream, emits(null));

      sut.validateCustomerField(faker.randomGenerator.string(100));
      sut.validateCustomerField(faker.randomGenerator.integer(100).toString());
    });
    test("Should emit correct values if is empty", () {
      expectLater(
        sut.customerErrorStream,
        emitsInOrder([null, ValidationError.requiredField]),
      );

      sut.validateCustomerField("");
    });
    test("Should call validation correctly", () {
      final searchValue = faker.randomGenerator.string(10);
      sut.validateCustomerField(searchValue);

      verify(() => validation.validate(
            field: "customer",
            input: {"customer": searchValue},
          )).called(1);
    });
  });

  group("Update selected covenant", () {
    test("Should update selected covenant correctly", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });
    });
    test("Should clear authorizationPendingModel", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      expect(sut.authorizationPendingModel, null);
    });

    test("Should clear selectedCovenant when customer is null", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );
      await sut.updateSelectedCovenant(null, faker.randomGenerator.string(10));

      expect(sut.selectedCovenant, {});
    });
  });

  group("Finish sale request by covenant", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );
    });

    // test("Should call finish sale request concentrador with correct values",
    //     () async {
    //   await sut.updateSelectedCovenant(
    //     customersViewModel[0],
    //     faker.randomGenerator.integer(100).toString(),
    //   );

    //   await sut.finishSaleRequestByCovenant(
    //     paymentPresenter: paymentPresenter,
    //     homePresenter: homePresenter,
    //     closePagesUntilHomePage: () {},
    //     printedProductsPresenter: printedProductsPresenter,
    //     showErrorMessageReturnedByBs: (_) {},
    //     customerPassword: customersViewModel[0].HasPassword,
    //   );

    //   verify(
    //     () => finishSaleRequestConcentrador.finish(
    //       pdvNumber: 100,
    //       commandNumber: homePresenter.commandNumberMock!.toInt(),
    //       finalizations: [
    //         ConcentratorFinalizationModel(
    //           FinalizationId:
    //               FinalizationIdentification.covenant.finalizationId,
    //           Value: printedProductsPresenter.printedProductsMock.TotalLiquid
    //               .toDouble(),
    //           ValueLiquid: printedProductsPresenter
    //               .printedProductsMock.TotalLiquid
    //               .toDouble(),
    //           PortionQuantity: 1,
    //           AuthorizationCode: soapResponse.response,
    //           AuthorizationType: 2,
    //           //Customer = 1,
    //           //Convene = 2,
    //           //DevolutionCredit = 3,
    //           //FinancialCredit = 4,
    //           //FidelityCredit = 5
    //         )
    //       ],
    //     ),
    //   ).called(1);
    // });
    test("Should call load printed on success", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(
        () => printedProductsPresenter.loadPrinted(homePresenter.commandNumberMock!),
      ).called(1);
    });
    test("Should call authorize covenant limit use by code", () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(
        () => covenantLimit.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity!,
          covenantCode: covenantCode.toInt(),
          customerCode: customersViewModel[0].Code!.toInt(),
          value: printedProductsPresenter.printedProductsMock.TotalLiquid
              .toDouble(),
        ),
      ).called(1);
    });
    test(
        "Should not finish sale request concentrador when soap response returns error type",
        () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      covenantLimit
          .mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(SoapResponse(
        response: faker.randomGenerator.string(10),
        responseType: SoapResponseType.error,
      ));

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verifyNever(
        () => finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
          finalizations: null,
        ),
      );
    });
    test("Should clear authorizationPendingModel on success", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      expect(sut.authorizationPendingModel, null);
    });

    // test(
    //     "Should not call covenantAuthorizationIsPendant.update with false value on finish throws",
    //     () async {
    //   await sut.updateSelectedCovenant(
    //     customersViewModel[0],
    //     faker.randomGenerator.integer(100).toString(),
    //   );

    //   finishSaleRequestConcentrador.mockError();

    //   await sut.finishSaleRequestByCovenant(
    //     paymentPresenter: paymentPresenter,
    //     homePresenter: homePresenter,
    //     closePagesUntilHomePage: () {},
    //     printedProductsPresenter: printedProductsPresenter,
    //     showErrorMessageReturnedByBs: (_) {},
    //     customerPassword: customersViewModel[0].HasPassword,
    //   );

    //   expect(
    //     sut.authorizationPendingModel,
    //     AuthorizationPendingModel(code: soapResponse.response, isPending: true),
    //   );
    // });

    test(
        "Should call updateSaleRequest with correct customerCode and covenantCode",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => updateSaleRequest.update(
            model: SaleRequestModel(
              CovenantCode: sut.selectedCovenant.values.first!.toInt(),
              CustomerCode: sut.selectedCovenant.keys.first.toInt(),
            ),
            commandNumberWithThreeNumbers:
                homePresenter.commandNumberMock!.padLeft(3, "0"),
            saleRequestId: printedProductsPresenter
                .printedProductsMock.SaleRequestId
                .toInt(),
          )).called(1);
    });

    test("Should call checkPasswordByCustomerCode", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verify(() => checkPasswordByCustomerCode.validate(
            customerCode: customersViewModel[0].Code!.toInt(),
            password: customersViewModel[0].HasPassword!,
          )).called(1);
    });
    test(
        "Should not call checkPasswordByCustomerCode if customerPassword is empty",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: "",
      );

      verifyNever(() => checkPasswordByCustomerCode.validate(
            customerCode: customersViewModel[0].Code!.toInt(),
            password: "",
          ));
    });
    test(
        "Should not call covenantLimit validation if selectedCustomer has invalid password",
        () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      final errorSoapResponse = SoapResponse(
        response: faker.randomGenerator.string(10),
        responseType: SoapResponseType.error,
      );

      checkPasswordByCustomerCode.mockCheck(errorSoapResponse);

      await sut.finishSaleRequestByCovenant(
        paymentPresenter: paymentPresenter,
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
        customerPassword: customersViewModel[0].HasPassword,
      );

      verifyNever(
        () => covenantLimit.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity!,
          covenantCode: covenantCode.toInt(),
          customerCode: customersViewModel[0].Code!.toInt(),
          value: printedProductsPresenter.printedProductsMock.TotalLiquid
              .toDouble(),
        ),
      );
    });
  });
}
