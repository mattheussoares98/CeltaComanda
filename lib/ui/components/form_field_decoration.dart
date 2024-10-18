import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

InputDecoration formFieldDecoration({
  required BuildContext context,
  required String? hintText,
  required String labelText,
  required String? errorText,
  Widget? suffixIcon,
  bool? showCounterText = true,
}) =>
    InputDecoration(
      labelText: labelText,
      suffixIcon: suffixIcon,
      errorText: errorText,
      hintText: hintText,
      counterText: showCounterText == false ? "" : null,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Color.fromARGB(255, 171, 35, 35),
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: getStringSize(context) * 0.6,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontSize: getStringSize(context) * 0.6,
      ),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: getStringSize(context) * 0.6,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.grey,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Color.fromARGB(255, 171, 35, 35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
