import 'dart:convert';
import 'package:tsp_base/src/models/interface_jsonable.dart';

import 'registery_types.dart';

class Message<T extends Jsonable> implements Jsonable {
  static final Type = 'message';

  final String event;
  final String contentType;
  final T content;

  Message(this.event, this.content) : contentType = content.type;

  factory Message.fromJson(Map<String, dynamic> json) {
    final contentType = json['content-type'];
    final rawContent = json['content'];
    final jsonContent = jsonDecode(rawContent);
    final content = typeMap[contentType]!(jsonContent);
    return Message(
      json['event'],
      content as T,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'content-type': contentType,
      'content': content.toJson(),
    };
  }

  @override
  String get type => Message.Type;
}
