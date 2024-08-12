import 'package:flutter/material.dart';

import '../../../../../ui/pages/menus/components/components.dart';

class LandscapeEvaluateService extends StatefulWidget {
  const LandscapeEvaluateService({super.key});

  @override
  State<LandscapeEvaluateService> createState() => _LandscapeEvaluateServiceState();
}

class _LandscapeEvaluateServiceState extends State<LandscapeEvaluateService> {
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
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
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
            ),
          ),
        ],
      ),
    );
  }
}
