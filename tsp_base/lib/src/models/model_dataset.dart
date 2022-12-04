import 'dart:math';

import 'model_edge.dart';
import 'model_node.dart';

class Dataset {
  final List<Node> nodes;
  final Map<String, List<Edge>> _edgePartitions = {};

  List<List<Edge>> get edgePartition => _edgePartitions.values.toList();

  List<Edge> get edges => _edgePartitions.isNotEmpty
      ? _edgePartitions.values
          .reduce((acc, edges) => acc.followedBy(edges).toList())
      : [];

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

  void putEdges(Iterable<Edge> edges, String partition) {
    final partitionEdges = _edgePartitions[partition] ?? <Edge>[];
    partitionEdges.addAll(edges);
    _edgePartitions.putIfAbsent(partition, () => partitionEdges);
  }

  void removeEdges(Iterable<Edge> edges, String partition) {
    final partitionEdges = _edgePartitions[partition] ?? <Edge>[];
    edges.forEach(partitionEdges.remove);
    _edgePartitions.putIfAbsent(partition, () => partitionEdges);
  }

  void clearEdges(String partition) {
    final partitionEdges = _edgePartitions[partition] ?? <Edge>[];
    partitionEdges.clear();
    _edgePartitions.putIfAbsent(partition, () => partitionEdges);
  }

  final List<void Function()> _listeners = [];

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void notifyChange() {
    _listeners.forEach((callback) {
      callback();
    });
  }
}
