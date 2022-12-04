import 'package:tsp_base/src/models/interface_jsonable.dart';
import 'package:tsp_base/src/models/model_edge.dart';

class EdgeEvent implements Jsonable {
  static const Type = 'edge-event';
  static const event_add = 'add-edges';
  static const event_remove = 'remove-edges';
  static const event_replace = 'replace-edges';
  static const event_done = 'done';
  final List<Edge> edges;
  final String event;

  const EdgeEvent({
    required this.edges,
    required this.event,
  });

  const EdgeEvent.done()
      : edges = const [],
        event = EdgeEvent.event_done;

  factory EdgeEvent.fromJson(Map<String, dynamic> json) {
    return EdgeEvent(
        edges: (json['edges'] as List).map((e) => Edge.fromJson(e)).toList(),
        event: json['event']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'edges': edges.map((e) => e.toJson()).toList(),
      'event': event,
    };
  }

  @override
  String get type => EdgeEvent.Type;
}
