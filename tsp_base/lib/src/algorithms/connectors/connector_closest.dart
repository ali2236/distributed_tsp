import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

class ClosestConnector {
  Iterable<Edge> connect(List<Node> p1, List<Node> p2) {
    final edges = <Edge>[];
    for (var i = 0; i < p1.length; i++) {
      for (var j = 0; j < p2.length; j++) {
        final edge = Edge(firstNode: p1[i], secondNode: p2[j]);
        edges.add(edge);
      }
    }

    edges.sort();

    return edges;
  }
}
