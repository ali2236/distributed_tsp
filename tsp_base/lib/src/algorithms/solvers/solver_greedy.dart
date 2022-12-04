import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/extensions/extension_nodes.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_node.dart';

class GreedySolver implements Solver {
  const GreedySolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes,  Stream<EdgeEvent> sync) async* {
    final tsp = nodes
        .map((n1) => nodes
            .map((n2) => Edge(firstNode: n1, secondNode: n2).length)
            .toList())
        .toList();
    int counter = 0;
    int j = 0, i = 0;
    var min = 2.0;
    List<int> visitedRouteList = [];

    visitedRouteList.add(0);
    final route = List.generate(tsp.length, (i) => -1);

    while (i < tsp.length && j < tsp[i].length) {
      // Corner of the Matrix
      if (counter >= tsp[i].length - 1) {
        break;
      }

      if (j != i && !(visitedRouteList.contains(j))) {
        if (tsp[i][j] < min) {
          min = tsp[i][j];
          route[counter] = j + 1;
        }
      }
      j++;

      if (j == tsp[i].length) {
        min = 2.0;
        visitedRouteList.add(route[counter] - 1);
        j = 0;
        i = route[counter] - 1;
        counter++;
      }
    }

    i = route[counter - 1] - 1;

    for (j = 0; j < tsp.length; j++) {
      if ((i != j) && tsp[i][j] < min) {
        min = tsp[i][j];
        route[counter] = j + 1;
      }
    }

    yield EdgeEvent(
      edges: route.map((i) => nodes[i - 1]).toList().path.toList(),
      event: EdgeEvent.event_add,
    );

    yield EdgeEvent.done();
  }

/*  @override
  Stream<List<Edge>> solve(List<Node> nodes, void Function() onFinish) async* {
    final n = nodes.length;
    final edges = [
      for(var i=0;i<nodes.length;i++)
        for(var j=i+1;j<nodes.length;j++)
          Edge(firstNode: nodes[i], secondNode: nodes[j])
    ]..sort();

    final degree = <Node, int>{};
    var count = 0;
    while (count < n-1) {
      final shortestEdge = edges.removeAt(0);

      final d1 = degree.putIfAbsent(shortestEdge.firstNode, () => 0);
      final d2 = degree.putIfAbsent(shortestEdge.secondNode, () => 0);

      if (d1 == 2 || d2 == 2) continue;



      degree[shortestEdge.firstNode] = d1 + 1;
      degree[shortestEdge.secondNode] = d2 + 1;

      yield [shortestEdge];
      count++;
    }

    onFinish();
  }*/
}
