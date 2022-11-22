import 'package:tsp_base/src/models/interface_jsonable.dart';

class NullContent implements Jsonable {

  static const Type = 'Null';

  const NullContent();

  factory NullContent.fromJson(Map<String, dynamic> json) => const NullContent();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String get type => Type;

}