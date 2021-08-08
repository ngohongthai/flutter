class Person {
  String name;
  int? age;

  Person({required this.name, this.age = 0});

  void printInfo() {
    if (age == null) {
      print("name: ${this.name}, age: invalid");
    } else {
      print("name: ${this.name}, age: ${this.age}");
    }
  }
}

void main() {
  Person p1 = new Person(name: "Thai", age: 30);
  p1.printInfo();

  Person p2 = new Person(name: "Thai2", age: null);
  p2.printInfo();

  //with default value
  Person p3 = new Person(name: "Thai3");
  p3.printInfo();
}
