import 'model_edge.dart';
import 'model_node.dart';

abstract class Solver {
  Stream<Edge> solve(Stream<Node> nodes);
}