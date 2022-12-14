import 'package:tsp_base/core.dart';
import 'package:tsp_base/src/models/interface_jsonable.dart';

import 'model_node.dart';

class Edge implements Jsonable, Comparable<Edge> {
  static const Type = 'edge';
  final Node firstNode, secondNode;

  const Edge({
    required this.firstNode,
    required this.secondNode,
  });

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      firstNode: Node(json['x1'], json['y1']),
      secondNode: Node(json['x2'], json['y2']),
    );
  }

  double get length => firstNode.distanceFrom(secondNode).abs();

  @override
  int get hashCode => firstNode.hashCode ^ secondNode.hashCode;

  @override
  bool operator ==(Object other) {
    return super == other ||
        other is Edge &&
            (firstNode == other.firstNode || secondNode == other.secondNode) &&
            (secondNode == other.firstNode || firstNode == other.secondNode);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'x1': firstNode.x,
      'y1': firstNode.y,
      'x2': secondNode.x,
      'y2': secondNode.y,
    };
  }

  @override
  String get type => Edge.Type;

  @override
  int compareTo(Edge other) {
    return length.compareTo(other.length);
  }

  @override
  String toString() {
    return 'Edge{firstNode: $firstNode, secondNode: $secondNode, length: $length}';
  }
}
