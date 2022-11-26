import 'package:tsp_base/src/models/model_node.dart';
import 'package:tsp_base/src/models/model_node_distance.dart';

Iterable<List<Node>> groupNearestNByGroupCount(
    List<Node> nodes, int groups) sync* {
  final unselected = List.of(nodes);
  final groupLen = nodes.length ~/ groups;
  for (var i = 0; i < groups && unselected.isNotEmpty; i++) {
    final primary = unselected.removeAt(0);
    if (unselected.isNotEmpty) {
      final len = i == groups - 1 ? unselected.length : groupLen - 1;
      final nearestK = unselected.nearestPointsTo(primary).sublist(0, len);
      yield nearestK;
    }
  }
}

Iterable<List<Node>> groupNearestNByGroupLength(
    List<Node> nodes, int groupLen) {
  final groups = nodes.length ~/ groupLen;
  return groupNearestNByGroupCount(nodes, groups);
}

extension NodeOrder on List<Node> {
  List<Node> nearestPointsTo(Node node) {
    final distances = map((n) => NodeDistance(n, n.distanceFrom(node))).toList()
      ..sort();
    final nearestNodes = distances.map((e) => e.node).toList();
    return nearestNodes;
  }
}
