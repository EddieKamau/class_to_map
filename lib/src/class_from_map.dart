import 'dart:mirrors';

/// This converts a Map<String, dynamic> to the given class
/// For example
/// ```dart
/// class Test{
///   String name = 'name';
///   int age = 0;
/// }
///
/// {
///   "name": 'My name',
///   "age": 12
/// }.toClass<Test>();
/// ```
/// to
/// ```dart
/// Test{
///   name = 'My name';
///   age = 12;
/// }
extension ClassFromMapExtension on Map<String, dynamic> {
  /// Ff the class being implemented requires arugemts, (positional or named) pass the (default)values as [positionalArguments] and or [namedArguments]
  T toClass<T>(
      {List? positionalArguments, Map<Symbol, dynamic>? namedArguments}) {
    // creates an instance of the give class
    final InstanceMirror im = reflect(Activator.createInstance(
        T, const Symbol(''), positionalArguments, namedArguments) as T?);

    // converts the map to the given class
    T process(InstanceMirror instanceMirror, Map? obj) {
      final ClassMirror _classMirror = instanceMirror.type;

      void processClassMirror(InstanceMirror instanceMirror,
          ClassMirror classMirror, Map? _object) {
        classMirror.declarations.values.forEach((item) {
          final String name = MirrorSystem.getName(item.simpleName);
          if (item is VariableMirror) {
            dynamic _value;

            _value = (_object ?? {})[name];
            try {
              if (item.type.reflectedType == double) {
                instanceMirror.setField(item.simpleName,
                    _value == null ? null : double.parse(_value.toString()));
              } else if (item.type.reflectedType == int) {
                instanceMirror.setField(item.simpleName,
                    _value == null ? null : int.parse(_value.toString()));
              } else {
                instanceMirror.setField(item.simpleName, _value);
              }
            } catch (e) {
              rethrow;
            }
          }
        });
      }

      processClassMirror(instanceMirror, _classMirror, obj);

      return instanceMirror.reflectee;
    }

    try {
      return process(im, this);
    } catch (e) {
      rethrow;
    }
  }
}

class Activator {
  static dynamic createInstance(Type? type,
      [Symbol? constructor,
      List? arguments,
      Map<Symbol, dynamic>? namedArguments]) {
    if (type == null) {
      throw ArgumentError("type: $type");
    }

    final typeMirror = reflectType(type);
    if (typeMirror is ClassMirror) {
      return typeMirror
          .newInstance(constructor ?? const Symbol(""), arguments ?? const [],
              namedArguments ?? {})
          .reflectee;
    } else {
      throw ArgumentError("Cannot create the instance of the type '$type'.");
    }
  }
}
