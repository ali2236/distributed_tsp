abstract class Jsonable {
  String get type;
  Map<String, dynamic> toJson();
}