import 'package:tsp_base/src/models/interface_jsonable.dart';

class Slave implements Jsonable {
  static final Type = 'slave';
  final String id;

  const Slave(this.id);

  factory Slave.fromJson(Map<String, dynamic> json) {
    return Slave(json['path']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
      };

  @override
  String get type => Type;
}
