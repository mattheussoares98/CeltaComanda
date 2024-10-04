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

  late LoadCustomerSpy loadCustomer;
  late ValidationSpy validation;
  late FinishSaleRequestConcentradorSpy finishSaleRequestConcentrador;
  late CovenantLimitSpy covenantLimit;
  late CovenantAuthorizationIsPendantSpy covenantAuthorizationIsPendant;

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
    covenantAuthorizationIsPendant = CovenantAuthorizationIsPendantSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
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
      finishSaleRequestConcentrador: finishSaleRequestConcentrador,
      covenantLimit: covenantLimit,
      covenantAuthorizationIsPendant: covenantAuthorizationIsPendant,
    );
  }

  void mockSuccess() {
    loadCustomer.mockLoadCustomer(customersEntitys);
    covenantLimit
        .mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(soapResponse);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(HomePresenterSpy());
  });

  group("Get customer", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getCustomer(faker.randomGenerator.string(10));
    });
    test("Should emit correct values on not found customer", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.notFound]));

      loadCustomer.mockLoadCustomer(null);
      await sut.getCustomer(faker.randomGenerator.string(10));
    });
    test("Should emit correct values on throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadCustomer.mockError();
      await sut.getCustomer(faker.randomGenerator.string(10));
    });
    test(
        "Should call loadCustomer with searchType 3 when cant convert value to int",
        () async {
      final valueToSearch = faker.randomGenerator.string(100);

      await sut.getCustomer(valueToSearch);

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

      await sut.getCustomer(valueToSearch);

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

      await sut.getCustomer(valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 1, //ExactCnpjCpfNumber
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 2 when is number and dont found cpf",
        () async {
      loadCustomer.mockLoadCustomer(null);

      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomer(valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 2, //ExactCode
        ),
      ).called(1);
    });
    test(
        "Should call loadCustomer with searchType 4 when is number and dont found cpf and exactcode",
        () async {
      loadCustomer.mockLoadCustomer(null);

      final valueToSearch =
          faker.randomGenerator.decimal(min: 10000000000000).toInt().toString();

      await sut.getCustomer(valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 4,
        ),
      ).called(1);
    });
    test("Should not get customer if value is empty", () async {
      await sut.getCustomer("");

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

      await sut.getCustomer("any");
    });

    test("Should clear selectedCovenant", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });

      await sut.getCustomer("any");

      expect(sut.selectedCovenant, {});
    });
    test("Should call covenantAuthorizationIsPendant.update with false value",
        () async {
      await sut.getCustomer("any");

      verify(() => covenantAuthorizationIsPendant.update(null)).called(1);
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
  });

  group("Update selected covenant", () {
    test("Should update selected covenant correctly", () async {
      String newValue = faker.randomGenerator.string(10);
      await sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });
    });
    test("Should call covenantAuthorizationIsPendant.update with false value",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      verify(
        () => covenantAuthorizationIsPendant.update(null),
      ).called(1);
    });
    test("Should emit correct values", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      verify(
        () => covenantAuthorizationIsPendant.update(null),
      ).called(1);
    });

    test(
        "Should not update selectedCovenant when covenantAuthorizationIsPendant throws",
        () async {
      covenantAuthorizationIsPendant.mockUpdateError();

      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.string(10),
      );

      expect(sut.selectedCovenant, {});
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
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
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
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );
    });

    test("Should call finish sale request concentrador with correct values",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
          finalizations: null,
        ),
      ).called(1);
    });
    test("Should call load printed on success", () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => printedProductsPresenter.loadPrinted(homePresenter),
      ).called(1);
    });
    test("Should call authorize covenant limit use by code", () async {
      String covenantCode = faker.randomGenerator.integer(100).toString();
      await sut.updateSelectedCovenant(customersViewModel[0], covenantCode);

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => covenantLimit.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseDataBuilder.enterpriseDataEntity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity!,
          covenantCode: covenantCode.toInt(),
          customerCode: customersViewModel[0].Code!.toInt(),
          value:
              printedProductsPresenter.printedProducts!.TotalLiquid.toDouble(),
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
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verifyNever(
        () => finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
          finalizations: null,
        ),
      );
    });
    test(
        "Should call covenantAuthorizationIsPendant.update with true value on success",
        () async {
      final code = faker.randomGenerator.string(10);

      covenantAuthorizationIsPendant.mockUpdate(
        AuthorizationPendingModel(
          code: code,
          isPending: true,
        ),
      );
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => covenantAuthorizationIsPendant.update(
          AuthorizationPendingModel(
            code: code,
            isPending: true,
          ),
        ),
      ).called(1);
    });
    test(
        "Should call covenantAuthorizationIsPendant.update with false value on success",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => covenantAuthorizationIsPendant.update(null),
      ).called(2);
    });
    test(
        "Should not call covenantAuthorizationIsPendant.update with false value on finish throws",
        () async {
      await sut.updateSelectedCovenant(
        customersViewModel[0],
        faker.randomGenerator.integer(100).toString(),
      );

      finishSaleRequestConcentrador.mockError();

      await sut.finishSaleRequestByCovenant(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
        showErrorMessageReturnedByBs: (_) {},
      );

      verify(
        () => covenantAuthorizationIsPendant.update(null),
      ).called(1);
    });
  });

  group("Get covenant authorization is pendant", () {
    test("Should call covenantAuthorizationIsPendant.get", () async {
      await sut.getCovenantAuthorizationIsPendant();

      verify(() => covenantAuthorizationIsPendant.get()).called(1);
    });
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getCovenantAuthorizationIsPendant();
    });
    test("Should emit correct values on throws", () async {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      covenantAuthorizationIsPendant.mockGetError();

      await sut.getCovenantAuthorizationIsPendant();
    });

    test("Should return correct value if usecase return true", () async {
      final value = await sut.getCovenantAuthorizationIsPendant();

      expect(value, true);
    });
    test("Should return correct value if usecase throw", () async {
      covenantAuthorizationIsPendant.mockGetError();

      final value = await sut.getCovenantAuthorizationIsPendant();

      expect(value, false);
    });
    test("Should return correct value if usecase return false", () async {
      covenantAuthorizationIsPendant.mockGet(false);

      final value = await sut.getCovenantAuthorizationIsPendant();

      expect(value, false);
    });
  });
}
