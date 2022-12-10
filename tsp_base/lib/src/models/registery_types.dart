import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_message.dart';
import 'package:tsp_base/src/models/model_null_content.dart';
import 'package:tsp_base/src/models/model_slave.dart';
import 'package:tsp_base/src/models/model_string_content.dart';

import 'model_edge.dart';
import 'model_list_content.dart';
import 'model_node.dart';

Map<String, Function(Map<String, dynamic> json)> typeMap = {
  Message.Type : Message.fromJson,
  NullContent.Type : (_) => NullContent(),
  Node.Type : Node.fromJson,
  Edge.Type : Edge.fromJson,
  ListContent.Type : ListContent.fromJson,
  StringContent.Type : StringContent.fromJson,
  EdgeEvent.Type : EdgeEvent.fromJson,
};