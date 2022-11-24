import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tsp_base/core.dart';
import 'package:tsp_slave/solver_order.dart';

void main(List<String> arguments) async {
  const defaultUrl = 'localhost:2022';
  stdout.write('Enter Master Url(default=$defaultUrl):');
  final input = stdin.readLineSync();
  final url = (input?.isNotEmpty ?? false) ? input : defaultUrl;
  final websocket = await WebSocket.connect('ws://$url', headers: {
    'id': Random().nextInt(200000).toString(),
  });
  print('connected');
  final solver = OrderSolver();
  final inputController = StreamController<Node>();
  final outputStream = solver.solve(inputController.stream);
  websocket.listen((event) {
    if(event is String){
      final jsonMessage = jsonDecode(event);
      final message = Message.fromJson(jsonMessage);
      if(message.event == Events.point){
        final point = message.content as Node;
        inputController.sink.add(point);
      }
    }
  });
  outputStream.listen((edge) {
    websocket.add(Message(Events.edge, edge).jsonString);
  });
}
