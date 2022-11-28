import 'package:tsp_base/src/models/interface_jsonable.dart';

class StringContent implements Jsonable {

  static const Type = 'String';

  final String text;

  const StringContent(this.text);

  factory StringContent.fromJson(Map<String, dynamic> json) => StringContent(json['text']);

  @override
  Map<String, dynamic> toJson() {
    return {'text' : text};
  }

  @override
  String get type => Type;

}