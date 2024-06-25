import 'package:flutter/material.dart';

class StatelessDemo1 extends StatelessWidget {
  const StatelessDemo1({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    debugPrint("[flutter-print] build in StatelessDemo1");
    return FittedBox(
      child: Text(text),
    );
  }
}
