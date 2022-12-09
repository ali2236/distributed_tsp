import 'package:tsp_base/core.dart';
import 'package:tsp_base/src/algorithms/connectors/connector.dart';
import 'package:tsp_base/src/models/model_edge.dart';

import '../find_nearest_node.dart';

class GreedyConnector extends Connector {
  const GreedyConnector();

  @override
  void connect(Dataset dataset) {
    final partitionEdgeNodes = dataset.edgePartition
        .map(
          (partition) => findEdgeNodes(partition.toSet()).toList(),
    )
        .toList();
    final connections = <Edge>[];
    for (var i = 0; i < partitionEdgeNodes.length; i++) {
      final partition = partitionEdgeNodes[i];
      final first = partition.removeAt(0);
      final otherPartitions = List.of(partitionEdgeNodes)
        ..removeAt(i);
      final nodes = otherPartitions
          .reduce((acc, nodes) => acc.followedBy(nodes).toList());
      var second = findNearestNode(nodes, first);
      final secondPartition = partitionEdgeNodes
          .firstWhere((partition) => partition.contains(second));
      secondPartition.remove(second);
      final edge = Edge(firstNode: first, secondNode: second);
      dataset.putEdges([edge], Connector.id);
    }
  }
}