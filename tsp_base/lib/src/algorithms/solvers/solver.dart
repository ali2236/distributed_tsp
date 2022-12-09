import 'package:tsp_base/src/models/model_edge_event.dart';

import '../../models/model_node.dart';

abstract class Solver {
  const Solver();

  Stream<EdgeEvent> solve(List<Node> nodes);
}
