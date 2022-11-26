import 'package:tsp_base/core.dart';

abstract class Connector {

  const Connector();

  // find tsp edge nodes
  Set<Node> findEdgeNodes(Set<Edge> edges) {
    final nodes = <Node>{};
    for (var edge in edges) {
      if (nodes.contains(edge.firstNode)) {
        nodes.remove(edge.firstNode);
      } else {
        nodes.add(edge.firstNode);
      }

      if (nodes.contains(edge.secondNode)) {
        nodes.remove(edge.secondNode);
      } else {
        nodes.add(edge.secondNode);
      }
    }
    return nodes;
  }

  Set<Edge> connect(Set<Edge> edges);
}
