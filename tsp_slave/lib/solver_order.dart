import 'package:tsp_base/core.dart';

class OrderSolver implements Solver {
  @override
  Stream<Edge> solve(Stream<Node> nodes) async* {
    while(true){
      final n = await nodes.take(2).toList();
      final edge = Edge(firstNode: n[0], secondNode: n[1]);
      yield edge;
    }
  }

}