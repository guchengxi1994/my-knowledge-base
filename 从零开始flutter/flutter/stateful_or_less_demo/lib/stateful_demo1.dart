import 'package:flutter/material.dart';

class StatefulDemo1 extends StatefulWidget {
  const StatefulDemo1({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<StatefulDemo1> createState() => _StatefulDemo1State();
}

class _StatefulDemo1State extends State<StatefulDemo1> {
  @override
  Widget build(BuildContext context) {
    debugPrint("[flutter-print] build in StatefulDemo1");
    return FittedBox(
      child: Column(
        children: [
          Text(widget.text),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  debugPrint(
                      "[flutter-print] click inner stateful-widget button");
                });
              },
              child: const Text("内部刷新"))
        ],
      ),
    );
  }
}
