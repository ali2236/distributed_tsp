import 'package:tsp_base/core.dart';

import 'solver.dart';

class OrderSolver implements Solver {

  const OrderSolver();

  @override
  Stream<List<Edge>> solve(
    List<Node> nodes,
    void Function() onFinish,
  ) async* {
    for (var i = 0; i < nodes.length - 1; i++) {
      final edge = Edge(firstNode: nodes[i], secondNode: nodes[i + 1]);
      yield [edge];
      // await Future.delayed(Duration(milliseconds: 100));
    }
    onFinish();
  }
}
