import 'package:flutter/material.dart';

import '../../../../../ui/pages/menus/components/components.dart';

class PortraitEvaluateService extends StatefulWidget {
  const PortraitEvaluateService({super.key});

  @override
  State<PortraitEvaluateService> createState() =>
      _PortraitEvaluateServiceState();
}

class _PortraitEvaluateServiceState extends State<PortraitEvaluateService> {
  int? foodNote;
  int? drinkNote;
  int? environmentNote;
  int? serviceNote;
  int? costBenefitNote;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final suggestionCriticalOrPraiseController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    suggestionCriticalOrPraiseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EvaluateItems(
            updateFoodNote: (int index) {
              setState(() {
                foodNote = index + 1;
              });
            },
            updateDrinkNote: (int index) {
              setState(() {
                drinkNote = index + 1;
              });
            },
            updateEnvironmentNote: (int index) {
              setState(() {
                environmentNote = index + 1;
              });
            },
            updateServiceNote: (int index) {
              setState(() {
                serviceNote = index + 1;
              });
            },
            updateCostBenefitNote: (int index) {
              setState(() {
                costBenefitNote = index + 1;
              });
            },
            foodNote: foodNote,
            drinkNote: drinkNote,
            environmentNote: environmentNote,
            serviceNote: serviceNote,
            costBenefitNote: costBenefitNote,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
            child: ClientInformations(
              foodNote: foodNote,
              drinkNote: drinkNote,
              environmentNote: environmentNote,
              serviceNote: serviceNote,
              costBenefitNote: costBenefitNote,
              nameController: nameController,
              phoneController: phoneController,
              emailController: emailController,
              suggestionCriticalOrPraiseController:
                  suggestionCriticalOrPraiseController,
            ),
          )
        ],
      ),
    );
  }
}
