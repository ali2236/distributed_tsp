import 'package:tsp_base/src/models/interface_jsonable.dart';

class Node implements Jsonable{
  static const Type = 'node';
  final double x;
  final double y;

  const Node(this.x, this.y);

  factory Node.fromJson(Map<String, dynamic> json){
    return Node(json['x'], json['y']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'x' : x,
      'y' : y,
    };
  }

  @override
  String get type => Node.Type;
}