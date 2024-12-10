import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxParametersPresenter sut;

  late NavigateToSpy navigateTo;
  late ParametersDataSpy parametersData;

  late List<ParameterModel> parameters;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    parametersData = ParametersDataSpy();
  }

  void initPresenters() {
    sut = GetxParametersPresenter(
      navigateTo: navigateTo,
      parametersData: parametersData,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    parameters = [
      EntityFactory.makeParametersModel(),
      EntityFactory.makeParametersModel(),
    ];
  }

  void initMockSuccess() {
    parametersData.mockLoad(parameters);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makePdvEntity());
  });

  group("Load parameters", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.parametersStream, emitsInOrder([null, parameters]));

      await sut.loadParameters();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.parametersStream, emits(null));

      parametersData.mockLoadError();

      await sut.loadParameters();
    });
    test("Should call load local parameters", () async {
      await sut.loadParameters();

      verify(() => parametersData.load()).called(1);
    });
    test("Should add parameter manually if dont exists", () async {
      expectLater(
          sut.parametersStream,
          emitsInOrder([
            null,
            [
              ParameterModel(
                name: "R.string.parameters", //TODO create string helper
                enabled: false,
                key: ParameterKey.enableSearchProducts,
              )
            ]
          ]));

      parametersData.mockLoad([]);

      await sut.loadParameters();
    });
    test("Should add parameter locally automatic if dont exists", () async {
      parametersData.mockLoad([]);

      await sut.loadParameters();

      verify(() => parametersData.update([
            ParameterModel(
              name: "R.string.parameters", //TODO create string helper
              enabled: false,
              key: ParameterKey.enableSearchProducts,
            )
          ])).called(1);
    });
  });

  group("Change parameter", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
          sut.parametersStream,
          emits([
            ParameterModel(
              name: parameters[0].name,
              enabled: !parameters[0].enabled,
              key: parameters[0].key,
            ),
            parameters[1],
          ]));

      await sut.changeParameter(0);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder(([null, UIError.unexpected])),
      );

      parametersData.mockLoadError();

      await sut.changeParameter(0);
    });
    test("Should call update in success", () async {
      await sut.changeParameter(0);

      verify(() => parametersData.update([
            ParameterModel(
              name: parameters[0].name,
              enabled: !parameters[0].enabled,
              key: parameters[0].key,
            ),
            parameters[1],
          ])).called(1);
    });
  });
}
