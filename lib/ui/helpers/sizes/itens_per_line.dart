import 'package:flutter/material.dart';

int getItensPerLine(BuildContext context) {
  return (MediaQuery.of(context).size.width / 350).ceil();
}
