class Person {
  int? age;
  String? name;

  Person({this.age, this.name});

  void setAge(int a) {
    age = a;
  }

  void setName(String n) {
    name = n;
  }

  bool operator ==(Object other) {
    if (other is! Person) {
      return false;
    }
    return other.age == this.age;
  }

  @override
  int get hashCode => this.age.hashCode;
}

class Person2 {
  int age;
  String name;

  Person2({this.age = 0, this.name = "张三"});

  void setAge(int a) {
    age = a;
  }

  void setName(String n) {
    name = n;
  }
}

class Person3 {
  int age;
  String name;

  Person3({required this.age, required this.name});

  void setAge(int a) {
    age = a;
  }

  void setName(String n) {
    name = n;
  }
}
