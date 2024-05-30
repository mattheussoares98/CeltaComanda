import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromARGB(255, 76, 175, 80);
  const primaryColorDark = Color.fromARGB(255, 50, 120, 53);
  const primaryColorLight = Color.fromARGB(255, 120, 238, 124);
  const secondaryColor = Color.fromRGBO(0, 77, 64, 1);
  const secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);
  final disabledColor = Colors.grey[400];
  const dividerColor = Colors.grey;
  const textTheme = TextTheme(
      displayLarge: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark));
  final inputDecorationTheme = InputDecorationTheme(
    labelStyle: const TextStyle(
      color: primaryColorDark,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: disabledColor!,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: disabledColor,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: primaryColor,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: primaryColor,
      ),
    ),
  );
  final buttonTheme = ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));

  final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: primaryColorDark,
    foregroundColor: Colors.white,
  ));

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: secondaryColor,
    secondaryHeaderColor: secondaryColorDark,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    colorScheme: const ColorScheme.light(primary: primaryColor),
    // backgroundColor: Colors.white, deprecated
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    buttonTheme: buttonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
  );
}
