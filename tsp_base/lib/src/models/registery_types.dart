import 'package:tsp_base/src/models/model_message.dart';
import 'package:tsp_base/src/models/model_null_content.dart';
import 'package:tsp_base/src/models/model_slave.dart';

Map<String, Function(Map<String, dynamic> json)> typeMap = {
  Slave.Type : Slave.fromJson,
  Message.Type : Message.fromJson,
  NullContent.Type : (_) => NullContent(),
};