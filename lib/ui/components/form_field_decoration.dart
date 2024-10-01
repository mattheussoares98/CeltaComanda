import 'package:flutter/material.dart';

InputDecoration formFieldDecoration({
  required BuildContext context,
  required String? hintText,
  required String labelText,
  required String? errorText,
  Widget? suffixIcon,
}) =>
    InputDecoration(
      labelText: labelText,
      suffixIcon: suffixIcon,
      errorText: errorText,
      hintText: hintText,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          style: BorderStyle.solid,
          width: 1,
          color: Color.fromARGB(255, 171, 35, 35),
        ),
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
      ),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.normal,
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
