import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

class GreedySolver implements Solver {
  const GreedySolver();

  @override
  Stream<List<Edge>> solve(List<Node> nodes, void Function() onFinish) async* {
    final n = nodes.length;
    final edges = nodes
        .map((n1) => nodes.map((n2) => Edge(firstNode: n1, secondNode: n2)))
        .reduce((acc, e) => acc.followedBy(e))
        .toSet()
        .toList()
      ..sort();

    final degree = <Node, int>{};
    var count = 0;
    while (count < n) {
      final shortestEdge = edges.removeAt(0);

      final d1 = degree.putIfAbsent(shortestEdge.firstNode, () => 0);
      final d2 = degree.putIfAbsent(shortestEdge.secondNode, () => 0);

      if (d1 >= 2 || d2 >= 2) continue;

      degree[shortestEdge.firstNode] = d1 + 1;
      degree[shortestEdge.secondNode] = d2 + 1;

      yield [shortestEdge];
      count++;
    }

    onFinish();
  }
}
