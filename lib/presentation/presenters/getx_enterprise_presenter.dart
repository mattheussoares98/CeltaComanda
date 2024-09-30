import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxEnterpriseValidationPresenter extends GetxController
    with TextControllerManager, LoadingManager, FormManager, UIErrorManager
    implements EnterpriseValidationPresenter {
  final Validation validation;
  final LocalEnterpriseData localEntepriseData;
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;
  final CommandInformations commandInformations;
  final LocalCommandData localCommandData;
  final Persistent persistent;
  final LoadEnterpriseConcentradorParameters
      loadEnterpriseConcentradorParameters;

  GetxEnterpriseValidationPresenter({
    required this.validation,
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
    required this.commandInformations,
    required this.localCommandData,
    required this.persistent,
    required this.loadEnterpriseConcentradorParameters,
  });

  @override
  bool isUpdatedEnterpriseName = false;

  final _enterpriseError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get enterpriseErrorStream => _enterpriseError.stream;

  final _commandData = Rx<CommandViewModel?>(null);
  @override
  Stream<CommandViewModel?> get commandDataStream => _commandData.stream;

  @override
  Future<void> loadLocalData(HomePresenter homePresenter) async {
    EnterpriseDataBuilder.enterpriseDataEntity =
        await localEntepriseData.load();

    if (EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName.isNotEmpty ==
        true) {
      updateEnterpriseController(
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName);
    }

    isLoading = true;
    mainError = null;
    try {
      final commandEntity = await localCommandData.load();

      if (commandEntity == null) {
        throw Exception();
      }

      _commandData.value = CommandViewModel.fromEntity(commandEntity);

      if (commandEntity.isFixedCommandNumber !=
          homePresenter.isFixedCommandNumber) {
        await homePresenter.updateIsFixedCommandNumber();
      }
    } catch (e) {
      _commandData.value = const CommandViewModel(
        commandNumber: null,
        isFixedCommandNumber: null,
      );
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadRemoteEnterpriseData() async {
    try {
      final remoteData = await loadEnterpriseData.load();

      if (remoteData != null) {
        EnterpriseDataBuilder.enterpriseDataEntity = remoteData;
      } else {
        throw DomainError.enterpriseOrUrlNotFound;
      }

      if (EnterpriseDataBuilder
              .enterpriseDataEntity?.enterpriseName.isNotEmpty ==
          true) {
        enterpriseNameController.text =
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName;
        await localEntepriseData
            .add(EnterpriseDataBuilder.enterpriseDataEntity!);
      }

      if (EnterpriseDataBuilder.enterpriseDataEntity == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      }

      await loadEnterpriseConcentradorParameters
          .load(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!);
    } catch (e) {
      throw DomainError.enterpriseOrUrlNotFound;
    } finally {
      isUpdatedEnterpriseName = false;
    }
  }

  @override
  Future<void> getEnterpriseAndValidateApiIsAvailable({
    required CommandEntity commandEntity,
    required HomePresenter homePresenter,
  }) async {
    try {
      mainError = null;
      isLoading = true;

      await localEntepriseData.add(EnterpriseDataBuilder.enterpriseDataEntity!);

      if ((homePresenter.isGeneratingVersionToRede ||
              homePresenter.isGeneratingVersionToTablet) &&
          !commandEntity.isFixedCommandNumber) {
        throw DomainError.obligatoryFixedCommandNumber;
      }

      if (isUpdatedEnterpriseName ||
          EnterpriseDataBuilder.enterpriseDataEntity!.url == null) {
        await loadRemoteEnterpriseData();
      }

      await commandInformations.ticketIsPermitted(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandEntity.commandNumber == null ||
                commandEntity.commandNumber?.isEmpty == true
            ? "001"
            : commandEntity.commandNumber!,
      );

      await localCommandData.update(commandEntity);

      isLoading = false;
      await goToHomePage(homePresenter);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          break;
        case DomainError.obligatoryFixedCommandNumber:
          mainError = UIError.obligatoryFixedCommandNumber;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false}) {
    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName: value,
      url: null,
      enterpriseId: null,
      concentradorUrl: null,
      persistApp: null,
      urlCCS: null,
      useCovenant: null,
    );

    _enterpriseError.value = _validateField('enterpriseName');
    _validateForm();
    if (updateEnterpriseNameController == true) {
      isUpdatedEnterpriseName = true;
    }
  }

  UIError? _validateField(String field) {
    final formData = {
      'enterpriseName': enterpriseNameController.text,
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _enterpriseError.value == null &&
        enterpriseNameController.text.isNotEmpty == true;
  }

  @override
  Future<void> goToHomePage(HomePresenter homePresenter) async {
    navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
    if (EnterpriseDataBuilder.enterpriseDataEntity?.persistApp == true &&
        !homePresenter.isGeneratingVersionToRede) {
      await persistent.makePersistent();
    } else {
      await persistent.makeNotPersistent();
    }
  }

  @override
  Future<void> updateUseFixedCommandNumber(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;

    try {
      final commandViewModel = CommandViewModel(
        commandNumber: homePresenter.commandNumber,
        isFixedCommandNumber: (!homePresenter.isFixedCommandNumber).toString(),
      );

      await localCommandData.update(commandViewModel.toEntity());

      _commandData.value = commandViewModel;
      await homePresenter.updateIsFixedCommandNumber();
    } catch (e) {
      UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateCommandNumber({
    required String? newCommandValue,
    required HomePresenter homePresenter,
  }) {
    final commandWithPadLeft = newCommandValue?.padLeft(3, "0");

    homePresenter.updateCommandNumber(commandWithPadLeft);

    _commandData.value = CommandViewModel(
      commandNumber: commandWithPadLeft,
      isFixedCommandNumber: _commandData.value?.isFixedCommandNumber ?? "false",
    );
  }
}
