import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class SearchTypeRadios extends StatefulWidget {
  final void Function(int? value) updateSelectedOption;
  final int? selectedOption;
  const SearchTypeRadios({
    required this.updateSelectedOption,
    required this.selectedOption,
    super.key,
  });

  @override
  State<SearchTypeRadios> createState() => _SearchTypeRadiosState();
}

class _SearchTypeRadiosState extends State<SearchTypeRadios> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColorLight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: Text(R.string.internalcodeNameOrCpf,
                        style: TextStyle(
                          fontSize: StringSize.size,
                          color: Theme.of(context).primaryColor,
                        )),
                    contentPadding: EdgeInsets.all(0),
                    value: 0,
                    groupValue: widget.selectedOption,
                    onChanged: widget.updateSelectedOption,
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: Text(R.string.personalizedCode,
                        style: TextStyle(
                          fontSize: StringSize.size,
                          color: Theme.of(context).primaryColor,
                        )),
                    dense: true,
                    value: 1,
                    groupValue: widget.selectedOption,
                    onChanged: widget.updateSelectedOption,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: hasMinWidth(context) ? -5 : 0,
          left: 10,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                R.string.searchType,
                style: TextStyle(fontSize: StringSize.size),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
