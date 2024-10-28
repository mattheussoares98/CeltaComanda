import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';

class ClientInformations extends StatelessWidget {
  final int? foodNote;
  final int? drinkNote;
  final int? environmentNote;
  final int? serviceNote;
  final int? costBenefitNote;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController suggestionCriticalOrPraiseController;
  const ClientInformations({
    required this.foodNote,
    required this.drinkNote,
    required this.environmentNote,
    required this.serviceNote,
    required this.costBenefitNote,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.suggestionCriticalOrPraiseController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: R.string.name,
            hintText: R.string.name,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: R.string.cellPhone,
            hintText: R.string.cellPhone,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: R.string.email,
            hintText: R.string.email,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: suggestionCriticalOrPraiseController,
          decoration: InputDecoration(
            labelText: R.string.suggestionCriticalOrPraise,
            hintText: R.string.suggestionCriticalOrPraise,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await _sendAvaliation(
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
              context: context,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              R.string.sendEvaluation.toUpperCase(),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _sendAvaliation({
  required int? foodNote,
  required int? drinkNote,
  required int? environmentNote,
  required int? serviceNote,
  required int? costBenefitNote,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required TextEditingController emailController,
  required TextEditingController suggestionCriticalOrPraiseController,
  required BuildContext context,
}) async {
  if (foodNote == null) {
    snackBarMessage(
      context,
      R.string.msgEvaluateFood,
      backgroundColor: Colors.red,
    );
  } else if (drinkNote == null) {
    snackBarMessage(
      context,
      R.string.msgEvaluateDrink,
      backgroundColor: Colors.red,
    );
  } else if (environmentNote == null) {
    snackBarMessage(
      context,
      R.string.msgEvaluateEnvironment,
      backgroundColor: Colors.red,
    );
  } else if (serviceNote == null) {
    snackBarMessage(
      context,
      R.string.msgEvaluateService,
      backgroundColor: Colors.red,
    );
  } else if (costBenefitNote == null) {
    snackBarMessage(
      context,
      R.string.msgEvaluateCostBenefit,
      backgroundColor: Colors.red,
    );
  } else if (nameController.text.isEmpty) {
    snackBarMessage(
      context,
      R.string.msgWriteName,
      backgroundColor: Colors.red,
    );
  }
}
