import 'model_node.dart';

class Edge {
  final Node firstNode, secondNode;

  const Edge({
    required this.firstNode,
    required this.secondNode,
  });

  @override
  int get hashCode => firstNode.hashCode ^ secondNode.hashCode;

  @override
  bool operator ==(Object other) {
    return super == other ||
        other is Edge &&
            (firstNode == other.firstNode || firstNode == other.secondNode) &&
            (secondNode == other.secondNode || secondNode == other.secondNode);
  }
}
