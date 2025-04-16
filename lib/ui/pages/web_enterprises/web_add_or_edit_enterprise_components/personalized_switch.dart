import 'package:flutter/material.dart';

class PersonalizedSwitch extends StatelessWidget {
  final bool value;
  final void Function() changeValue;
  final String title;
  const PersonalizedSwitch({
    required this.value,
    required this.changeValue,
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          changeValue();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Switch(
                value: value,
                onChanged: (_) {
                  changeValue();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
