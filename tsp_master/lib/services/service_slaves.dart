import 'dart:convert';
import 'dart:io';

import 'package:destributed_tsp/splitters/splitter.dart';
import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';
import 'package:utility/utility.dart';

class SlavesService with ChangeNotifier {
  HttpServer? _server;
  Dataset? _dataset;
  final _slaves = <String, WebSocket>{};

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
      socket.listen(_onEvent);
      notifyListeners();
    });
    notifyListeners();
  }

  stop() {
    _server?.close(force: true);
    _server = null;
    _slaves.clear();
    _dataset = null;
    notifyListeners();
  }

  void _onEvent(event) {
    if (event is String) {
      final message = Message.fromJson(jsonDecode(event));
      _processMessage(message);
    }
  }

  void _processMessage(Message msg) {
    if(msg.event == Events.edge && msg.type == Edge.Type){
      _dataset?.edges.add(msg.content as Edge);
      _dataset?.notifyChange();
    } /*else if(msg.event == Events.edges){
      _dataset?.edges.addAll(msg.content as List<Edge>);
    }*/
  }

  int get salvesCount => _slaves.length;

  void startSolving(Dataset dataset, Splitter splitter) {
    _dataset = dataset;
    // divide points
    final chunks = splitter.split(dataset.nodes, salvesCount);

    // stream points to each slave
    final sockets = _slaves.values.toList();
    Future.forEach(List.generate(salvesCount, (i) => i), (i) async {
      final points = chunks[i];
      final socket = sockets[i];
      await Future.forEach(points, (point) async {
        await Future.microtask(() => socket.add(Message(Events.point, point).jsonString));
      });
    });

    // gather edges
    // done in [_onEvent]->[_processMessage]
  }
}
