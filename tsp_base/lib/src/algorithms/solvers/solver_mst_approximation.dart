import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_node.dart';

class MSTApproximationSolver implements Solver {
  @override
  Stream<EdgeEvent> solve(List<Node> nodes) async* {
    throw UnimplementedError();
  }
}
