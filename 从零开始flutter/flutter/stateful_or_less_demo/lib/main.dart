import 'package:flutter/material.dart';
import 'package:stateful_or_less_demo/stateful_demo1.dart';
import 'package:stateful_or_less_demo/stateless_demo1.dart';
import 'package:stateful_or_less_demo/stateless_demo2.dart';

import 'stateful_demo2.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int times = 0;
  final GlobalKey<StatefulDemo2State> globalKey = GlobalKey();

  final ValueNotifier<int> notifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StatelessDemo1(text: times.toString()),
            const StatefulDemo1(text: "aaa"),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    times += 1;
                  });
                  debugPrint("[flutter print] build in parent");
                },
                child: const Text("刷新")),
            const SizedBox(
              height: 40,
            ),
            StatefulDemo2(
              key: globalKey,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      globalKey.currentState!.addOne();
                    },
                    child: Text("+1")),
                ElevatedButton(
                    onPressed: () {
                      globalKey.currentState!.minusOne();
                    },
                    child: Text("-1")),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            ValueListenableBuilder(
                valueListenable: notifier,
                builder: (c, i, child) {
                  return StatelessDemo2(times: notifier.value);
                }),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      notifier.value += 1;
                    },
                    child: Text("+1")),
                ElevatedButton(
                    onPressed: () {
                      notifier.value -= 1;
                    },
                    child: Text("-1")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
