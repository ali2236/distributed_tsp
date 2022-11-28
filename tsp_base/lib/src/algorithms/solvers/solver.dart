import '../../models/model_edge.dart';
import '../../models/model_node.dart';

abstract class Solver {
  Stream<List<Edge>> solve(
    List<Node> nodes,
    void Function() onFinish,
  );
}
