import 'dart:async';

import 'package:tsp_base/src/algorithms/coordinator/coordinator.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_simulated_annealing.dart';
import 'package:tsp_base/src/algorithms/splitters/splitter_kmeans.dart';
import 'package:tsp_base/src/models/enum_events.dart';
import 'package:tsp_base/src/models/extensions/extension_edges.dart';
import 'package:tsp_base/src/models/extensions/extension_list.dart';
import 'package:tsp_base/src/models/model_dataset.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_list_content.dart';
import 'package:tsp_base/src/models/model_message.dart';
import 'package:tsp_base/src/models/model_node.dart';
import 'package:tsp_base/src/models/model_slave.dart';

import '../../models/model_string_content.dart';

class SACoordinator implements Coordinator {
  @override
  Future<void> solve(
    Dataset dataset,
    List<Slave> slaves,
  ) async {
    final nodes = dataset.nodes;
    final n = slaves.length;

    // partition using k-means
    final kmeans = KMeansSplitter();
    final clusters = kmeans.cluster(nodes, n);

    // make a graph of partition means
    final meanGraph = kmeans.pointsToNodes(clusters.means);

    // find hamiltonian cycle in cluster graph
    final clusterSolver = SimulatedAnnealingSolver(
      iterations: 1,
      cycle: true,
      changeStartEnd: true,
    );
    final clusterPath = await clusterSolver.solve(meanGraph).last.then(
          (ee) => ee.edges,
        );

    // assign each slave to a partition
    final partitionNodes =
        clusters.clusterPoints.map(kmeans.pointsToNodes).toList();
    final unorderedPartitions = [
      for (var i = 0; i < n; i++)
        Partition(slaves[i], partitionNodes[i], meanGraph[i])
    ];

    // order partitions based on path between them
    final orderReference = clusterPath.nodes;
    final partitions = <Partition>[];
    for (var i = 0; i < n; i++) {
      final p = unorderedPartitions.firstWhere(
        (p) => p.mean == orderReference[i],
      );
      unorderedPartitions.remove(p);
      partitions.add(p);
    }

    // slave communication setup
    final edgeCollectionCompleter = Completer();
    var localTspDone = 0;
    final connectorCompleter = Completer<void>();
    final lastConnectorCompleter = Completer<void>();
    var connectorsDone = 0;
    final pts = n > 2 ? n : n - 1;
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
          localTspDone++;
          // check done
          if (localTspDone == n) {
            edgeCollectionCompleter.complete();
          }
        }
        scheduleMicrotask(() {
          dataset.notifyChange();
        });
      }
    }

    for (var partition in partitions) {
      partition.slave.receiver = (msg) {
        // last(first) -> first(second)
        if (msg.event == Events.findConnection) {
          final list = msg.content as ListContent;
          final connections = list.items.cast<Edge>();
          var connection = connections.first;
          final index = partitions.indexOf(partition);
          final next = partitions[(index + 1) % n];
          var last = -1;
          var first = -1;
          var i = 0;
          // identify and correct anomaly
          do {
            connection = connections[i++];
            last = partition.nodes.indexOf(connection.firstNode);
            first = next.nodes.indexOf(connection.secondNode);
          } while ((connection.firstNode == partition.nodes.first ||
                  connection.secondNode == next.nodes.last) ||
              (last == -1 || first == -1) && i < connections.length);

          if (last == -1 || first == -1) {
            connection = connections[0];
          }

          partition.nodes.swap(last, partition.nodes.length - 1);
          next.nodes.swap(first, 0);

          dataset.putEdges([connection], 'connections');
          connectorsDone++;
          if (connectorsDone == pts) {
            connectorCompleter.complete();
          } else if (connectorsDone == n) {
            lastConnectorCompleter.complete();
          }
        } else {
          processMessage(msg);
        }
      };
    }

    // slave solver algorithm
    for (var slave in slaves) {
      final msg = Message(
        Events.solver,
        StringContent(n > 1 ? 'Simulated Annealing*' : 'SA - cycle'),
      );
      slave.sender!(msg);
    }

    await Future.delayed(const Duration(milliseconds: 50));

    // find closest next node for each partition
    if (n >= 2) {
      for (var i = 0; i < pts; i++) {
        final curr = partitions[i];
        final next = partitions[(i + 1) % n];

        final msg = Message(
          Events.findConnection,
          ListContent([ListContent(curr.nodes), ListContent(next.nodes)]),
        );
        curr.slave.sender!(msg);
      }

      await connectorCompleter.future;

      if (n == 2) {
        final curr = partitions[1];
        final next = partitions[0];
        final connection = dataset.edges.first;
        final p1 = List.of(curr.nodes);
        if (p1.length > 1) {
          p1.remove(connection.secondNode);
        }
        final p2 = List.of(next.nodes);
        if (p2.length > 1) {
          p2.remove(connection.secondNode);
        }
        final msg = Message(
          Events.findConnection,
          ListContent([ListContent(p1), ListContent(p2)]),
        );
        curr.slave.sender!(msg);

        await lastConnectorCompleter.future;
      }
    }

    //  2. run SA
    for (var partition in partitions) {
      final msg = Message(Events.points, ListContent(partition.nodes));
      partition.slave.sender!(msg);
    }

    await edgeCollectionCompleter.future;

    dataset.notifyChange();
    return;
  }
}

class Partition {
  final Slave slave;
  final List<Node> nodes;
  final Node mean;

  const Partition(this.slave, this.nodes, this.mean);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Partition &&
          runtimeType == other.runtimeType &&
          slave.id == other.slave.id;

  @override
  int get hashCode => slave.hashCode;
}
