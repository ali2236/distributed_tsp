import 'package:destributed_tsp/connectors/connector.dart';
import 'package:tsp_base/src/models/model_edge.dart';

class OrderConnector extends Connector {

  const OrderConnector();

  @override
  Set<Edge> connect(Set<Edge> edges) {
    final nodes = findEdgeNodes(edges).toList();
    final connections = <Edge>{};
    for (var i = 0; i < (nodes.length ~/ 2); i++) {
      final edge =
          Edge(firstNode: nodes[(i*2)], secondNode: nodes[(i * 2) + 1]);
      connections.add(edge);
    }
    return connections;
  }
}
