import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
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
  late LoadSaleRequestSpy loadSaleRequest;
  late FinishSaleRequestConcentradorSpy finishSaleRequestConcentrador;

  late List<CustomerEntity> customersEntitys;
  late List<CustomerViewModel> customersViewModel;
  late SaleRequestEntity saleRequestEntity;
  late SaleRequestModel saleRequestModel;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadCustomer = LoadCustomerSpy();
    validation = ValidationSpy();
    loadSaleRequest = LoadSaleRequestSpy();
    finishSaleRequestConcentrador = FinishSaleRequestConcentradorSpy();
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
    saleRequestEntity = EntityFactory.makeSaleRequestEntity();
    saleRequestModel = SaleRequestModel.fromEntity(saleRequestEntity);

    sut = GetxCovenantPresenter(
      loadCustomer: loadCustomer,
      validation: validation,
      loadSaleRequest: loadSaleRequest,
      finishSaleRequestConcentrador: finishSaleRequestConcentrador,
    );
  }

  void mockSuccess() {
    loadCustomer.mockLoadCustomer(customersEntitys);
    loadSaleRequest.mockLoadSaleRequest(saleRequestModel);
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

      loadCustomer.mockLoadCustomerError();
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
    test("Should update selected covenant correctly", () {
      String newValue = faker.randomGenerator.string(10);
      sut.updateSelectedCovenant(customersViewModel[0], newValue);

      expect(sut.selectedCovenant, {
        customersViewModel[0].Code: newValue,
      });
    });
  });

  group("Update customer and covenant and finish sale request temp", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadSaleRequest.mockError();

      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );
    });
    test("Should call loadSaleRequest with correct values", () async {
      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(
        () => loadSaleRequest.load(
            commandNumber: homePresenter.commandNumberMock!.toInt()),
      ).called(1);
    });
    test("Should call load sale request", () async {
      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(
        () => loadSaleRequest.load(
          commandNumber: homePresenter.commandNumberMock!.toInt(),
        ),
      ).called(1);
    });
    test("Should call finish sale request concentrador with correct values",
        () async {
      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(
        () => finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
          finalizationIdentification: 7,
        ),
      ).called(1);
    });
    test("Should call load printed on success", () async {
      await sut.updateCustomerAndCovenantAndFinishSaleRequestTemp(
        homePresenter: homePresenter,
        closePagesUntilHomePage: () {},
        printedProductsPresenter: printedProductsPresenter,
      );

      verify(
        () => printedProductsPresenter.loadPrinted(homePresenter),
      ).called(1);
    });
  });
}
