import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tsp_base/core.dart';

class SlavesService with ChangeNotifier {
  HttpServer? _server;
  Dataset? _dataset;
  Completer? _edgeCollection;
  var _done = 0;
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
      socket.listen((event) {
        if (event is String) {
          final message = Message.fromJson(jsonDecode(event));
          message.sender = slaveId;
          _processMessage(message);
        }
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
    _done = 0;
    notifyListeners();
  }

  void restart() {
    _dataset = null;
    _done = 0;
    notifyListeners();
  }

  void _processMessage(Message msg) {
    if (msg.event == Events.edgeEvent) {
      final ee = msg.content as EdgeEvent;
      final edges = ee.edges;
      if (ee.event == EdgeEvent.event_add) {
        _dataset?.putEdges(edges, msg.sender);
      } else if (ee.event == EdgeEvent.event_remove) {
        _dataset?.removeEdges(edges, msg.sender);
      } else if (ee.event == EdgeEvent.event_replace) {
        _dataset?.clearEdges(msg.sender);
        _dataset?.putEdges(edges, msg.sender);
      } else if (ee.event == EdgeEvent.event_done) {
        _done++;
        // check done
        if (_done == salvesCount) {
          _edgeCollection?.complete();
        }
      }
      _dataset?.notifyChange();
    }
  }

  int get salvesCount => _slaves.length;

  void startSolving(Dataset dataset, Splitter splitter, String solverId,
      Connector connector) async {
    _dataset = dataset;
    _done = 0;
    // set solver method
    for (var ws in _slaves.values) {
      ws.add(Message(Events.solver, StringContent(solverId)).jsonString);
    }

    await Future.delayed(const Duration(milliseconds: 50));

    // divide points
    final chunks = splitter.split(dataset.nodes, salvesCount);

    // stream points to each slave
    _edgeCollection = Completer();
    final sockets = _slaves.values.toList();
    Future.forEach(List.generate(salvesCount, (i) => i), (i) async {
      final points = chunks[i];
      final socket = sockets[i];
      await Future.microtask(
        () => socket.add(
          Message(Events.points, ListContent(points)).jsonString,
        ),
      );
    });

    // gather edges
    // done in [_processMessage]
    await _edgeCollection!.future;

    // connect
    final connectors = connector.connect(dataset);
    dataset.putEdges(connectors, 'connectors');
    dataset.notifyChange();

    // finished!
  }
}
