import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';

class SlavesService with ChangeNotifier {
  HttpServer? _server;
  Dataset? _dataset;
  final _slaves = <String, WebSocket>{};
  final slaves = <Slave>[];

  bool get started => _server != null;

  bool get _acceptsSlaves => _dataset == null;

  int get port => _server?.port ?? 2022;

  Future<void> start(int port) async {
    if (port == _server?.port) return;
    // close last socket
    stop();

    // create new socket
    _server = await HttpServer.bind('localhost', port);
    _server?.listen((req) async {
      if (!_acceptsSlaves) return;
      final socket = await WebSocketTransformer.upgrade(req);
      final slaveId = req.headers.value('id')!;
      _slaves.addAll({slaveId: socket});
      final slave = Slave(slaveId);
      slaves.add(slave);
      socket.listen((event) {
        if (event is String) {
          final message = Message.fromJson(jsonDecode(event));
          message.sender = slaveId;
          slave.receiveController.sink.add(message);
        }
      });
      slave.sendController.stream.listen((msg) {
        socket.add(msg.jsonString);
      });
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    _server?.close(force: true);
    _server = null;
    _slaves.clear();
    _dataset = null;
    slaves.clear();
    notifyListeners();
  }

  void restart() {
    _dataset = null;
    notifyListeners();
  }

  int get salvesCount => _slaves.length;

  void startSolving(
    Dataset dataset,
    Splitter splitter,
    String solverId,
    Connector connector,
  ) async =>
      await DefaultCoordinator().solve(
        splitter,
        solverId,
        connector,
        dataset,
        slaves,
      );
}
