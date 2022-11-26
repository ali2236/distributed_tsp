import 'dart:math';

import 'package:tsp_base/src/models/interface_jsonable.dart';

class Node implements Jsonable {
  static const Type = 'node';
  final double x;
  final double y;

  const Node(this.x, this.y);

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(json['x'], json['y']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  @override
  String get type => Node.Type;

  double distanceFrom(Node node) {
    return sqrt(pow(x - node.x, 2) + pow(y - node.y, 2));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
