import 'package:tsp_base/core.dart';

class OrderSolver implements Solver {
  @override
  Stream<List<Edge>> solve(
    Stream<List<Node>> nodes,
    void Function() onFinish,
  ) async* {
    await for (var part in nodes) {
      for (var i = 0; i < part.length - 1; i++) {
        final edge = Edge(firstNode: part[i], secondNode: part[i + 1]);
        yield [edge];
        await Future.delayed(Duration(milliseconds: 100));
      }
      onFinish();
    }
  }
}
