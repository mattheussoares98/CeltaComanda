import 'package:flutter/material.dart';

class Parameterspage extends StatelessWidget {
  const Parameterspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("parameters" + ""),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(child: Text("enable search of products" + "?")),
                    Switch(
                      value: false,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
