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

  StreamSubscription? _lastSolver;

  void _processMessage(Message msg) async {
    if (msg.event == Events.points) {
      final lc = msg.content as ListContent;
      final point = lc.items.cast<Node>();
      _lastSolver = _solver?.solve(point).listen((edgeEvent) {
        _socket.add(
          Message(Events.edgeEvent, edgeEvent).jsonString,
        );
      });
    } else if (msg.event == Events.solver) {
      final name = (msg.content as StringContent).text;
      final type = solvers[name];
      _solver = solverFactories[type]!();
      _lastSolver?.cancel();
    } else if (msg.event == Events.findConnection) {
      final partitions = msg.content as ListContent;
      final p1 = partitions.items[0] as ListContent;
      final p2 = partitions.items[1] as ListContent;
      final connections = ClosestConnector()
          .connect(
            p1.items.cast(),
            p2.items.cast(),
          )
          .toList();
      print('found connector');
      _socket.add(
        Message(Events.findConnection, ListContent(connections)).jsonString,
      );
    }
  }
}
