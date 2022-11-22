import 'dart:io';
import 'dart:math';

void main(List<String> arguments) async {
  const defaultUrl = 'localhost:2022';
  stdout.write('Enter Master Url(default=$defaultUrl):');
  final url = stdin.readLineSync() ?? defaultUrl;
  final websocket = await WebSocket.connect('ws://$url', headers: {
    'id': Random().nextInt(200000).toString(),
  });
  print('connected');
  await Future.delayed(Duration(days: 1));
}
