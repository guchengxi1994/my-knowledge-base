import 'package:flutter/material.dart';

class SecondWidget extends StatelessWidget {
  const SecondWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("这是一个懒加载的组件")),
    );
  }
}

extension SomeMethod on SecondWidget {
  static String toStr() {
    return "这是一个组件";
  }
}
