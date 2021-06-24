import 'package:class_to_map/class_to_map.dart';

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

void main() {
  // coverting a simple class
  print(Test().toMap());

  Map<String, dynamic> _testMap = {
    "val1": 'value 1',
    "val2": 2,
    "val3": {"a": "another value"} 
  };

  // converting a map to a simple class
  print(_testMap.toClass<Test>().val1);



  // converting a map to a class with required arguments
  Adress _adressTest= {
    "phoneNo": '254700000000', 
    "email": 'email@mail.mail'
  }.toClass<Adress>(positionalArguments: ['', '']);
  print(_adressTest.email);



  // converting a complex class to map
  final Person person = Person();
  print(person.toMap());

  Map<String, dynamic> personMap = {
    "name": 'person', 
    "age": 30, 
    "adress": {
      "phoneNo": '254700000000', 
      "email": 'email@mail.mail'
    }, 
    "children": [
      {"name": 'child 1', "age": 5}, 
      {"name": 'child 2', "age": 1}]
  };

  // map to class 
  Person _person = personMap.map((key, value) {
    if(key == 'adress'){
      return MapEntry(key, (value as Map<String, dynamic>?)?.toClass<Adress>(positionalArguments: ['', '']));
    }else if(key == "children"){
      List<Child>? _value = (value as List<Map<String, dynamic>>?)?.map((element) => element.toClass<Child>(positionalArguments: ['', 0])).toList();
      return MapEntry(key, _value);

    } else{
      return MapEntry(key, value);
    }
  }).toClass<Person>();
  print(_person.name);

  
}
