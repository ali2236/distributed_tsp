import 'package:tsp_base/src/algorithms/find_nearest_node.dart';
import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_node.dart';

class NearestNeighbourSolver implements Solver {
  const NearestNeighbourSolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes) async* {
    var v = List.of(nodes);
    var start = v.removeAt(0);
    var next = findNearestNode(v, start);
    v.remove(next);
    yield EdgeEvent(
      edges: [Edge(firstNode: start, secondNode: next)],
      event: EdgeEvent.event_add,
    );
    while (v.isNotEmpty) {
      // await Future.delayed(Duration(milliseconds: 100));
      start = next;
      next = findNearestNode(v, start);
      v.remove(next);
      yield EdgeEvent(
        edges: [Edge(firstNode: start, secondNode: next)],
        event: EdgeEvent.event_add,
      );
    }
    yield EdgeEvent.done();
  }
}
