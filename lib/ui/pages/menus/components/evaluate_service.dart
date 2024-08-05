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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                generateEvaluateItem(
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
                generateEvaluateItem(
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
                generateEvaluateItem(
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
                generateEvaluateItem(
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
                generateEvaluateItem(
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
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    hintText: "Nome",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Celular",
                    hintText: "Celular",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    hintText: "E-mail",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Sugestão, crítica ou elogio",
                    hintText: "Sugestão, crítica ou elogio",
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

Widget generateEvaluateItem({
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
