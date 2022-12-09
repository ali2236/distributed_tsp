import 'package:tsp_base/core.dart';

class ExactSolver extends Solver {
  const ExactSolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes) async* {
    yield EdgeEvent(
      edges: _Tour.bestTour(nodes.toSet()).edges,
      event: EdgeEvent.event_add,
    );
    yield EdgeEvent.done();
  }
}

class _Tour {
  final List<Edge> edges;
  int? _hashCode;

  _Tour(this.edges);

  _Tour.from(List<Node> nodes) : edges = createEdges(nodes);

  double get length =>
      edges.fold(.0, (double acc, Edge edge) => acc += edge.length);

  static Set<_Tour> permute(Set<Node> nodes) {
    var result = <_Tour>{};

    _Tour.streamPermute(nodes, (tour) {
      result.add(tour);
    });

    return result;
  }

  static List<Edge> createEdges(List<Node> nodes) {
    if (nodes.length <= 1) return [];
    var result = <Edge>[];
    var current = nodes.first;
    nodes.sublist(1).forEach((point) {
      result.add(Edge(firstNode: current, secondNode: point));
      current = point;
    });
    return result..add(Edge(firstNode: nodes.last, secondNode: nodes.first));
  }

  static void streamPermute(Set<Node> nodes, void onTour(_Tour tour)) {
    if (nodes.length < 2)
      throw ArgumentError("Points has to contain at least two points");

    innerPermute(List<Node> proto, Set<Node> nodes) {
      if (1 == nodes.length) {
        var tour = _Tour.from(proto..add(nodes.single));
        onTour(tour);
        return;
      }

      nodes.forEach((node) {
        var clone = Set.of(nodes);
        clone.remove(node);
        innerPermute(List.from(proto, growable: true)..add(node), clone);
      });
    }

    innerPermute([], nodes);
  }

  static _Tour bestTour(Set<Node> nodes) {
    if (nodes.length < 2)
      throw ArgumentError("Points has to contain at least two points");
    _Tour? best;

    _Tour.streamPermute(nodes, (tour) {
      if (null == best || best!.length > tour.length) best = tour;
    });

    return best!;
  }

  List<Edge> get sortedEdges => List.from(edges)..sort();

  @override
  bool operator ==(other) {
    if (other is! _Tour) return false;
    if (edges.length != other.edges.length) return false;
    var selfSorted = sortedEdges;
    var otherSorted = other.sortedEdges;

    for (int i = 0; i < selfSorted.length; i++) {
      if (selfSorted[i] != otherSorted[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    _hashCode ??= sortedEdges.hashCode;
    return _hashCode!;
  }

  @override
  toString() => edges.map((edge) => edge.toString()).join(" -> ");
}
