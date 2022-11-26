import 'model_edge.dart';
import 'model_node.dart';

abstract class Solver {
  Stream<List<Edge>> solve(
    Stream<List<Node>> nodes,
    void Function() onFinish,
  );
}
