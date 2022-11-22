import 'dart:math';

import 'model_edge.dart';
import 'model_node.dart';

class Dataset {
  final List<Node> nodes;
  final List<Edge> edges = [];

  Dataset(this.nodes);

  factory Dataset.generate(int nodes) {
    final random = Random();
    return Dataset(
      List.generate(
        nodes,
        (i) => Node(
          random.nextDouble(),
          random.nextDouble(),
        ),
      ),
    );
  }
}
