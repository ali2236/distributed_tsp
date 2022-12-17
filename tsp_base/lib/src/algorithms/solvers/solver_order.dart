import 'package:tsp_base/src/models/model_edge.dart';

import '../../models/model_edge_event.dart';
import '../../models/model_node.dart';
import 'solver.dart';

class OrderSolver implements Solver {
  const OrderSolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes) async* {
    for (var i = 0; i < nodes.length - 1; i++) {
      final edge = Edge(firstNode: nodes[i], secondNode: nodes[i + 1]);
      yield EdgeEvent(edges: [edge], event: EdgeEvent.event_add);
      // await Future.delayed(Duration(milliseconds: 50));
    }
    yield EdgeEvent.done();
  }
}
