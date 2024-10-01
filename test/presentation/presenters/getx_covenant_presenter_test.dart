import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxCovenantPresenter sut;

  late LoadCustomerSpy loadCustomer;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUseCases() {
    loadCustomer = LoadCustomerSpy();
  }

  void initPresenters() {}

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();

    sut = GetxCovenantPresenter(
      loadCustomer: loadCustomer,
    );
  }

  void mockSuccess() {}

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  group("Load customer", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.getCustomer(faker.randomGenerator.string(10));
    });
    test(
        "Should call loadCustomer with searchType 3 when cant convert value to int",
        () async {
      final valueToSearch = faker.randomGenerator.string(10);

      await sut.getCustomer(valueToSearch);

      verify(
        () => loadCustomer.load(
          value: valueToSearch,
          searchTypeInt: 3,
        ),
      ).called(1);
    });
  });
}
