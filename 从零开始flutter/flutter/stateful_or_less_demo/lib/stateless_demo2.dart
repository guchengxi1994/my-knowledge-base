import 'package:flutter/material.dart';

class StatelessDemo2 extends StatelessWidget {
  const StatelessDemo2({Key? key, required this.times}) : super(key: key);
  final int times;

  @override
  Widget build(BuildContext context) {
    debugPrint("[flutter-print] build in StatelessDemo2");
    return FittedBox(
      child: Text(times.toString()),
    );
  }
}
