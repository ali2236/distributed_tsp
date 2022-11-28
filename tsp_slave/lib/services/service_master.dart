import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tsp_base/core.dart';
import 'package:uuid/uuid.dart';

class MasterService {
  final WebSocket _socket;
  Solver? _solver;

  MasterService._(this._socket);

  static Future<MasterService> create(String url) async {
    final websocket = await WebSocket.connect('ws://$url', headers: {
      'id': const Uuid().v4(),
    });
    final service = MasterService._(websocket);
    websocket.listen(service._onEvent);
    return service;
  }

  void _onEvent(event) {
    if (event is String) {
      final message = Message.fromJson(jsonDecode(event));
      _processMessage(message);
    }
  }

  void _processMessage(Message msg) async {
    if (msg.event == Events.points) {
      final lc = msg.content as ListContent;
      final point = lc.items.cast<Node>();
      _solver?.solve(point, () {
        _socket.add(Message(Events.done, NullContent()).jsonString);
        print('done');
      }).listen((edges) {
        _socket.add(Message(Events.edges, ListContent(edges)).jsonString);
      });
    } else if (msg.event == Events.solver) {
      final name = (msg.content as StringContent).text;
      final type = solvers[name];
      _solver = solverFactories[type]!();
    }
  }
}
