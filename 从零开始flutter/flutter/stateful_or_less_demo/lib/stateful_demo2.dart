import 'package:flutter/material.dart';

class StatefulDemo2 extends StatefulWidget {
  const StatefulDemo2({Key? key}) : super(key: key);

  @override
  State<StatefulDemo2> createState() => StatefulDemo2State();
}

class StatefulDemo2State extends State<StatefulDemo2> {
  int times = 0;

  addOne() {
    times += 1;
    setState(() {});
  }

  minusOne() {
    times -= 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("[flutter-print] build in StatefulDemo2");
    return FittedBox(
      child: Text(times.toString()),
    );
  }
}
