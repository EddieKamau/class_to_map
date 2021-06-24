/// This packages provides two extensions, for converting a class to a Map<String dynamic> & vice versa
/// for example
/// ```dart
/// class Test{
///   String name = 'name';
///   int age = 20;
/// }
/// Test().toMap();
///
/// {"name": 'name', "age": 20}.toClass<Test>();
/// ```
library class_to_map;

export 'src/class_map.dart';
export 'src/class_from_map.dart';
