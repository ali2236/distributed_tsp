import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

extension PathNodes on List<Edge> {
  List<Node> get nodes {
    return map((e) => {e.firstNode, e.secondNode})
        .reduce((acc, e) => acc.union(e))
        .toList();
  }
}
