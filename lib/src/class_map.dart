import 'dart:mirrors';

/// This converts the give class to a Map representation of its values
/// For exampe
/// ```dart
/// class Test{
///   String name = "My name";
///   int age = 20;
///   List<Friend> friends = [Friend('Friend1'), Friend('Friend2')];
/// }
/// class Friend{
///   Friend(this.name);
///   late String name;
/// }
/// ```
/// to
/// ```dart
/// {
///   "name": 'My name',
///   "age": 20,
///   "friends": [{"name": 'Friend1'}, {"name": 'Friend2'}]
/// }
/// ```
extension ClassToMapExtension on Object {
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _finalMap = {};
    final InstanceMirror im = reflect(this);

    Map<String, dynamic> process(InstanceMirror instanceMirror) {
      Map<String, dynamic> _map = {};
      final ClassMirror _classMirror = instanceMirror.type;

      Map<String, dynamic> processClassMirror(InstanceMirror instanceMirror,
          ClassMirror classMirror, Map<String, dynamic> map) {
        classMirror.declarations.values.forEach((item) {
          if (item is VariableMirror) {
            // get the variable name
            final String name = MirrorSystem.getName(item.simpleName);

            // if value is list
            if (item.type.toString().contains("on 'List'")) {
              final List _lst = [];
              (instanceMirror.getField(item.simpleName).reflectee as List?)
                  ?.forEach((element) {
                // check if value is a class
                if (instanceMirror
                    .getField(item.simpleName)
                    .reflectee
                    .toString()
                    .contains("Instance of ")) {
                  // convert the class to Map
                  _lst.add(process(reflect(element)));
                } else {
                  _lst.add(element);
                }
                _map[name] = _lst;
              });

              // if value is map
            } else if (item.type.toString().contains("on 'Map'")) {
              final Map _newMap = {};
              (instanceMirror.getField(item.simpleName).reflectee as Map?)
                  ?.forEach((k, v) {
                // check if value is a class
                if (instanceMirror
                    .getField(item.simpleName)
                    .reflectee
                    .toString()
                    .contains("Instance of ")) {
                  // convert the class to Map
                  _newMap[k] = process(reflect(v));
                } else {
                  _newMap[k] = v;
                }
              });
              map[name] = _newMap;
            } else {
              // check if value is a class
              if (instanceMirror
                  .getField(item.simpleName)
                  .reflectee
                  .toString()
                  .contains("Instance of ")) {
                final InstanceMirror _nestedIm =
                    reflect(instanceMirror.getField(item.simpleName).reflectee);
                // convert the nested class to Map
                map[name] = process(_nestedIm);
              } else if (!item.isPrivate) {
                // get the value of the variable
                map[name] = instanceMirror.getField(item.simpleName).reflectee;
              }
            }
          }
        });
        return map;
      }

      return processClassMirror(instanceMirror, _classMirror, _map);
    }

    _finalMap.addAll(process(im));
    return _finalMap;
  }
}
