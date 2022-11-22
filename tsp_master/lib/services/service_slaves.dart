import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';

class SlavesService with ChangeNotifier {
  HttpServer? _server;
  final _slaves = <String, WebSocket>{};

  bool get started => _server != null;
  int get port => _server?.port ?? 2022;

  Future<void> start(int port) async {
    if(port == _server?.port) return;
    // close last socket
    stop();

    // create new socket
    _server = await HttpServer.bind('localhost', port);
    _server?.listen((req) async {
      final socket = await WebSocketTransformer.upgrade(req);
      final slaveId = req.headers.value('id')!;
      _slaves.addAll({slaveId: socket});
      socket.listen(_onEvent);
      notifyListeners();
    });
    notifyListeners();
  }

  stop() {
    _server?.close(force: true);
    _server = null;
    _slaves.clear();
    notifyListeners();
  }

  void _onEvent(event) {
    if (event is String) {
      final message = Message.fromJson(jsonDecode(event));
      _processMessage(message);
    }
  }

  void _processMessage(Message msg) {

  }

  int get salvesCount => _slaves.length;


}
