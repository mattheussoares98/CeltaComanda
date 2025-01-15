import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late GetxWebEnterprisesConfigurationsPresenter sut;

  late LoadAllEnterprisesSpy loadAllEnterprises;

  void initUseCases() {
    loadAllEnterprises = LoadAllEnterprisesSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesConfigurationsPresenter(
      loadAllEnterprises: loadAllEnterprises,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
  }

  void mockSuccess() {}

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {});
}
