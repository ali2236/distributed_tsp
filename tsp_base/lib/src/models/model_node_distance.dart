import 'model_node.dart';

class NodeDistance implements Comparable<NodeDistance> {
  final Node node;
  final double distance;

  NodeDistance(this.node, this.distance);

  @override
  int compareTo(NodeDistance other) {
    return distance.compareTo(other.distance);
  }
}