import 'dart:convert';

import 'package:tsp_base/src/models/interface_jsonable.dart';

extension JsonableString on Jsonable {
  String get jsonString => jsonEncode(toJson());
}