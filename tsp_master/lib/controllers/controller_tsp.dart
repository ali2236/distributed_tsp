

import 'package:tsp_base/core.dart';

class TspController {
  final Dataset dataset;
  final int systems;

  TspController({
    required this.dataset,
    required this.systems,
  });

  void solve() {
    for (var i = 0; i < dataset.nodes.length ~/ 2; i++) {
      final edge = Edge(
        firstNode: dataset.nodes[i],
        secondNode: dataset.nodes[i * 2],
      );
      dataset.edges.add(edge);
    }
  }
}
