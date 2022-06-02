import 'package:dart_sample/c1.dart';

void main() {
  var p1 = Person(age: 18, name: "张三");
  var p2 = Person(age: 18, name: "张三");
  print(p1 == p2);
  print(identical(p1, p2));

  Set s = Set();
  s.add(p1);
  s.add(p2);

  print(s.toList().length);
}
