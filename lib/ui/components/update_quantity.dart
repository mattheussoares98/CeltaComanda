import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'components.dart';

class UpdateQuantity extends StatefulWidget {
  final double quantity;
  final void Function() reduceQuantity;
  final void Function() addQuantity;
  final TextEditingController? quantityController;
  final void Function(String?)? updateQuantity;
  final double? maxQuantity;
  const UpdateQuantity({
    required this.quantity,
    required this.reduceQuantity,
    required this.addQuantity,
    this.updateQuantity,
    this.quantityController,
    this.maxQuantity,
    super.key,
  });

  @override
  State<UpdateQuantity> createState() => _UpdateQuantityState();
}

class _UpdateQuantityState extends State<UpdateQuantity> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && widget.quantityController != null) {
        widget.quantityController?.text =
            widget.quantity.toString().toBrazilianNumber();
      }
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.quantityController != null)
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: widget.quantityController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  if (formKey.currentState?.validate() == false) {
                    return;
                  }

                  if (widget.updateQuantity != null) {
                    widget.updateQuantity!(value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return R.string.msgInvalidNumber;
                  } else if (value.contains(".") && value.contains(",")) {
                    return R.string.msgInvalidNumber;
                  } else if (value.split(".").length > 2 ||
                      value.split(",").length > 2) {
                    return R.string.msgInvalidNumber;
                  } else if (value.toDouble() < 0.001) {
                    return R.string.msgInvalidNumber;
                  }
                  return null;
                },
                decoration: formFieldDecoration(
                  context: context,
                  hintText: R.string.quantity,
                  labelText: R.string.quantity,
                  errorText: null,
                  suffixIcon: widget.maxQuantity == null
                      ? null
                      : Text(
                          "${R.string.maximumAbbreviated} ${widget.maxQuantity.toString().toBrazilianNumber(0)}  ",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                ),
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleAvatar(
              isAddingQuantity: false,
              updateQuantity:
                  widget.quantity <= 1 ? null : widget.reduceQuantity,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  maxRadius: ScreenSize.hasMinWidth ? 100 : MediaQuery.of(context).size.width * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: FittedBox(
                      child: Text(
                        widget.quantity.toString().toBrazilianNumber(
                              widget.quantityController == null ? 0 : 3,
                            ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: StringSize.size * 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _CircleAvatar(
              updateQuantity: widget.addQuantity,
              isAddingQuantity: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  final void Function()? updateQuantity;
  final bool isAddingQuantity;

  const _CircleAvatar({
    required this.updateQuantity,
    required this.isAddingQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.hasMinWidth ? 100 : MediaQuery.of(context).size.width * 0.2,
      width: ScreenSize.hasMinWidth ? 100 : MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColorLight,
      ),
      child: InkWell(
          onTap: updateQuantity,
          child: Icon(isAddingQuantity ? Icons.add : Icons.remove)),
    );
  }
}
