import 'package:tsp_base/src/algorithms/find_nearest_node.dart';
import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

class GreedySolver implements Solver {

  const GreedySolver();

  @override
  Stream<List<Edge>> solve(List<Node> nodes, void Function() onFinish) async* {
    var v = List.of(nodes);
    var start = v.removeAt(0);
    var next = findNearestNode(v, start);
    v.remove(next);
    yield [Edge(firstNode: start, secondNode: next)];
    while(v.isNotEmpty){
      start = next;
      next = findNearestNode(v, start);
      v.remove(next);
      yield [Edge(firstNode: start, secondNode: next)];
    }
    onFinish();
  }

}