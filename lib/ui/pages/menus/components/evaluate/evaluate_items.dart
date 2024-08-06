import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class EvaluateItems extends StatefulWidget {
  final Function(int index) updateFoodNote;
  final Function(int index) updateDrinkNote;
  final Function(int index) updateEnvironmentNote;
  final Function(int index) updateServiceNote;
  final Function(int index) updateCostBenefitNote;
  final int? foodNote;
  final int? drinkNote;
  final int? environmentNote;
  final int? serviceNote;
  final int? costBenefitNote;
  const EvaluateItems({
    required this.updateFoodNote,
    required this.updateDrinkNote,
    required this.updateEnvironmentNote,
    required this.updateServiceNote,
    required this.updateCostBenefitNote,
    required this.foodNote,
    required this.drinkNote,
    required this.environmentNote,
    required this.serviceNote,
    required this.costBenefitNote,
    super.key,
  });

  @override
  State<EvaluateItems> createState() => _EvaluateItemsState();
}

class _EvaluateItemsState extends State<EvaluateItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: [
          _generateEvaluateItem(
            context: context,
            text: "Comida",
            icon: Icons.food_bank,
            updateIndex: widget.updateFoodNote,
            evaluateNumber: widget.foodNote,
          ),
          _generateEvaluateItem(
            context: context,
            text: "Bebida",
            icon: Icons.wine_bar,
            updateIndex: widget.updateDrinkNote,
            evaluateNumber: widget.drinkNote,
          ),
          _generateEvaluateItem(
            context: context,
            text: "Ambiente",
            icon: Icons.house,
            updateIndex: widget.updateEnvironmentNote,
            evaluateNumber: widget.environmentNote,
          ),
          _generateEvaluateItem(
            context: context,
            text: "Atendimento",
            icon: Icons.person,
            updateIndex: widget.updateServiceNote,
            evaluateNumber: widget.serviceNote,
          ),
          _generateEvaluateItem(
            context: context,
            text: "Custo benefício",
            icon: Icons.monetization_on_rounded,
            updateIndex: widget.updateCostBenefitNote,
            evaluateNumber: widget.costBenefitNote,
          ),
        ],
      ),
    );
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
