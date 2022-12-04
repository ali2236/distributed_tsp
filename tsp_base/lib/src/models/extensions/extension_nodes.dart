import 'package:tsp_base/src/models/model_node.dart';

import '../model_edge.dart';

extension Path on List<Node> {
  Iterable<Edge> get path sync* {
    for (var i = 0; i < length - 1; i++) {
      final n1 = this[i];
      final n2 = this[i + 1];
      final edge = Edge(firstNode: n1, secondNode: n2);
      yield edge;
    }
  }

  double get pathLength =>
      path.map((e) => e.length).reduce((acc, val) => acc + val);
}
