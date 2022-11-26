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
  final inputController = StreamController<List<Node>>();
  final outputStream = solver.solve(inputController.stream.asBroadcastStream(), (){
    websocket.add(Message(Events.done, NullContent()).jsonString);
    print('done');
  });
  outputStream.listen((edges) {
    websocket.add(Message(Events.edges, ListContent(edges)).jsonString);
  });
  websocket.listen((event) {
    if(event is String){
      final jsonMessage = jsonDecode(event);
      final message = Message.fromJson(jsonMessage);
      if(message.event == Events.points){
        final lc = message.content as ListContent;
        final point = lc.items.cast<Node>();
        inputController.sink.add(point);
      }
    }
  });

}
