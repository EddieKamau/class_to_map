import 'package:class_to_map/class_to_map.dart';
import 'package:test/test.dart';

void main() {
  group('A group of class to map', () {

    test('Simple class', () {
      expect(Test().toMap(), {"val1": 'value 1', "val2": 2, "val3": {"a": "another value"} });
    });

    test('Complex class', () {
      expect(
        Person().toMap(), 
        {
          "name": 'person', 
          "age": 30, 
          "adress": {
            "phoneNo": '254700000000', 
            "email": 'email@mail.mail'
          }, 
          "children": [
            {"name": 'child 1', "age": 5}, 
            {"name": 'child 2', "age": 1}]
        }
      );
    });

    
  });


  group('A group of map to class', () {

    test('Simple class', () {
      expect({"val1": 'value 1', "val2": 2, "val3": {"a": "another value"} }.toClass<Test>().val1, Test().val1);
    });


    test('A class with required posinal arguments', () {
      expect(
        {"phoneNo": '254700000000', "email": 'email@mail.mail'}.toClass<Adress>(positionalArguments: ['', '']).email, 
        Adress('email@mail.mail', '254700000000').email
      );
    });

    test('Complex class', () {
      expect(
        {
          "name": 'person', 
          "age": 30, 
          "adress": {
            "phoneNo": '254700000000', 
            "email": 'email@mail.mail'
          }.toClass<Adress>(positionalArguments: ['', '']), 
          "children": [
            {"name": 'child 1', "age": 5}.toClass<Child>(positionalArguments: ['', 0]), 
            {"name": 'child 2', "age": 1}.toClass<Child>(positionalArguments: ['', 0])
          ]
        }.toClass<Person>().name,

        Person().name
      );
    });

    
  });

  
}



class Test {
    String val1 = "value 1";
    int val2 = 2;
    Map val3 = {"a": "another value"};
  }

class Person {
  String name = 'person';
  int age = 30;
  Adress adress = Adress('email@mail.mail', '254700000000');
  List<Child> children = [
    Child("child 1", 5),
    Child("child 2", 1),
  ];
}

class Adress {
  Adress(this.email, this.phoneNo);
  String phoneNo;
  String email;
}

class Child {
  Child(this.name, this.age);
  String name;
  int age;
}