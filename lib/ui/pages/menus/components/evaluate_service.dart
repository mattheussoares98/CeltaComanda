import 'package:clean_celta_mobile/ui/components/alert_message.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class EvaluateService extends StatefulWidget {
  const EvaluateService({super.key});

  @override
  State<EvaluateService> createState() => _EvaluateServiceState();
}

class _EvaluateServiceState extends State<EvaluateService> {
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
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                _generateEvaluateItem(
                  context: context,
                  text: "Comida",
                  icon: Icons.food_bank,
                  updateIndex: (int index) {
                    setState(() {
                      foodNote = index + 1;
                    });
                  },
                  evaluateNumber: foodNote,
                ),
                _generateEvaluateItem(
                  context: context,
                  text: "Bebida",
                  icon: Icons.wine_bar,
                  updateIndex: (int index) {
                    setState(() {
                      drinkNote = index + 1;
                    });
                  },
                  evaluateNumber: drinkNote,
                ),
                _generateEvaluateItem(
                  context: context,
                  text: "Ambiente",
                  icon: Icons.house,
                  updateIndex: (int index) {
                    setState(() {
                      environmentNote = index + 1;
                    });
                  },
                  evaluateNumber: environmentNote,
                ),
                _generateEvaluateItem(
                  context: context,
                  text: "Atendimento",
                  icon: Icons.person,
                  updateIndex: (int index) {
                    setState(() {
                      serviceNote = index + 1;
                    });
                  },
                  evaluateNumber: serviceNote,
                ),
                _generateEvaluateItem(
                  context: context,
                  text: "Custo benefício",
                  icon: Icons.monetization_on_rounded,
                  updateIndex: (int index) {
                    setState(() {
                      costBenefitNote = index + 1;
                    });
                  },
                  evaluateNumber: costBenefitNote,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    hintText: "Nome",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Celular",
                    hintText: "Celular",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    hintText: "E-mail",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: suggestionCriticalOrPraiseController,
                  decoration: const InputDecoration(
                    labelText: "Sugestão, crítica ou elogio",
                    hintText: "Sugestão, crítica ou elogio",
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
                      "Enviar avaliação".toUpperCase(),
                    ),
                  ),
                ),
              ],
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
    showAlertMessage(context, "Avalie a comida", Colors.red);
  } else if (drinkNote == null) {
    showAlertMessage(context, "Avalie a bebida", Colors.red);
  } else if (environmentNote == null) {
    showAlertMessage(context, "Avalie o ambiente", Colors.red);
  } else if (serviceNote == null) {
    showAlertMessage(context, "Avalie o atendimento", Colors.red);
  } else if (costBenefitNote == null) {
    showAlertMessage(context, "Avalie o custo benefício", Colors.red);
  } else if (nameController.text.isEmpty) {
    showAlertMessage(context, "Informe o seu nome", Colors.red);
  }
}

Widget _generateEvaluateItem({
  required String text,
  required IconData icon,
  required Function(int) updateIndex,
  required int? evaluateNumber,
  required BuildContext context,
}) {
  return SizedBox(
    height: 100,
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColorLight,
                size: 35,
              ),
            ),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return IconButton(
                onPressed: () {
                  updateIndex(index);
                },
                icon: Icon(
                  Icons.star,
                  color: (index + 1) <= (evaluateNumber ?? 0)
                      ? Colors.amber
                      : Theme.of(context).primaryColorLight,
                ),
              );
            },
          ),
        ),
        const Divider(height: 10, thickness: 0.2),
      ],
    ),
  );
}
