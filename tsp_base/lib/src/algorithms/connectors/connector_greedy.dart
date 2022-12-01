import 'package:tsp_base/src/algorithms/connectors/connector.dart';
import 'package:tsp_base/src/models/model_edge.dart';

import '../find_nearest_node.dart';

class GreedyConnector extends Connector {
  const GreedyConnector();

  @override
  Set<Edge> connect(Set<Edge> edges) {
    final nodes = findEdgeNodes(edges).toList();
    final connections = <Edge>{};

    while(nodes.isNotEmpty){
      var first = nodes.removeAt(0);
      var second = findNearestNode(nodes, first);
      nodes.remove(second);
      connections.add(Edge(firstNode: first, secondNode: second));
    }
    return connections;
  }
}
