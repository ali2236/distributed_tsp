import 'dart:async';

import 'package:tsp_base/src/algorithms/connectors/connector.dart';
import 'package:tsp_base/src/algorithms/coordinator/coordinator.dart';
import 'package:tsp_base/src/algorithms/splitters/splitter.dart';
import 'package:tsp_base/src/models/model_dataset.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_list_content.dart';
import 'package:tsp_base/src/models/model_message.dart';
import 'package:tsp_base/src/models/model_slave.dart';
import 'package:tsp_base/src/models/model_string_content.dart';

import '../../models/enum_events.dart';

class DefaultCoordinator implements Coordinator {
  final Splitter splitter;
  final String solverId;
  final Connector connector;

  const DefaultCoordinator(this.splitter, this.solverId, this.connector);

  @override
  Future<void> solve(
    Dataset dataset,
    List<Slave> slaves,
  ) async {
    var done = 0;
    // set solver method
    for (var slave in slaves) {
      final msg = Message(Events.solver, StringContent(solverId));
      slave.sender!(msg);
    }

    await Future.delayed(const Duration(milliseconds: 50));

    // divide points
    final chunks = splitter.split(dataset.nodes, slaves.length);

    // stream points to each slave
    final edgeCollection = Completer();
    final sinks = slaves.map((e) => e.sender).toList();

    void processMessage(Message msg) {
      if (msg.event == Events.edgeEvent) {
        final ee = msg.content as EdgeEvent;
        final edges = ee.edges;
        if (ee.event == EdgeEvent.event_add) {
          dataset.putEdges(edges, msg.sender);
        } else if (ee.event == EdgeEvent.event_remove) {
          dataset.removeEdges(edges, msg.sender);
        } else if (ee.event == EdgeEvent.event_replace) {
          dataset.clearEdges(msg.sender);
          dataset.putEdges(edges, msg.sender);
        } else if (ee.event == EdgeEvent.event_done) {
          done++;
          // check done
          if (done == slaves.length) {
            edgeCollection.complete();
          }
        }
        dataset.notifyChange();
      }
    }

    for (var s in slaves) {
      s.receiver = (event) {
        processMessage(event);
      };
    }

    Future.forEach(List.generate(slaves.length, (i) => i), (i) async {
      final points = chunks[i];
      final sink = sinks[i];
      await Future.microtask(
        () => sink!(Message(Events.points, ListContent(points))),
      );
    });

    // gather edges
    // done in [_processMessage]
    await edgeCollection.future;

    // connect
    connector.connect(dataset);

    await Future.delayed(Duration(milliseconds: 1000), () {
      dataset.notifyChange();
    });
    dataset.notifyChange();

    // finished!
  }
}
