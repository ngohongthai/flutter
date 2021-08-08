int addIntNumber(int a, int b) {
  return a+b;
} 

double addDoubleNumber(double a, double b) {
  return a + b;
}

//Class
class Person {
  String name = "Thai";
  int age = 30;
}

void main() {
  for(int i = 0; i < 5; i++) {
    print("hello ${i+1}");
  }
  print("1+1 = ${addIntNumber(1, 1)}");
  double a = 2.0;
  double b = 3.0;
  print("2.0 + 3.0 = ${addDoubleNumber(a, b)}");

  // var for dinamic variable
  print("\n ---- test functions and dinamic variable ----");
  var firstResult = addDoubleNumber(1, 2);
  firstResult += 1;
  print("firstResult: ${firstResult}");

  // --- String
  print("\n ----- test String -----");
  String name = "Thai";
  int age = 30;
  print("Hello ${name} - age: ${age}");

  // -- Class
  print("\n ---- test class ----");
  Person p1 = new Person();
  print(p1);
  print("Hello person: name: ${p1.name} age: ${p1.age}");

}