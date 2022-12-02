import 'package:tsp_base/src/models/interface_jsonable.dart';
import 'package:tsp_base/src/models/model_edge.dart';

class EdgeEvent implements Jsonable {
  static const Type = 'edge-event';
  final Edge edge;
  final bool remove;

  const EdgeEvent({
    required this.edge,
    required this.remove,
  });

  factory EdgeEvent.fromJson(Map<String, dynamic> json) {
    return EdgeEvent(
      edge: Edge.fromJson(json['edge']),
      remove: json['remove']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'edge': edge.toJson(),
      'remove' : remove,
    };
  }

  @override
  String get type => EdgeEvent.Type;
}