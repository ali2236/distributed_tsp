import 'dart:math';

import 'package:tsp_base/core.dart';
import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_nearest_neighbor.dart';
import 'package:tsp_base/src/models/extensions/extension_edges.dart';
import 'package:tsp_base/src/models/extensions/extension_nodes.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_node.dart';

class SimulatedAnnealingSolver implements Solver {
  const SimulatedAnnealingSolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes) async* {
    final nnEdges = (await NearestNeighbourSolver()
            .solve(nodes)
            .toList()
            .then((e) => e.map((e) => e.edges)))
        .reduce((acc, e) => acc.followedBy(e).toList())
        .toList();

    var iteration = 5;
    var path = nnEdges.nodes;
    while(iteration-->0){
      var lastEvent = EdgeEvent(edges: [], event: EdgeEvent.event_replace);
      await for(var event in _solve(path)){
        lastEvent = event;
        yield event;
      }
      path = lastEvent.edges.nodes;
    }

    yield EdgeEvent.done();
    print('done');
  }

  Stream<EdgeEvent> _solve(List<Node> nodes) async* {
    double temp = 1.0;
    double coolingRate = 0.00001;
    var currentSolution = List.of(nodes);
    var currentLen = currentSolution.pathLength;
    var best = currentSolution;
    var bestLen = currentLen;
    final r = Random();
    final n = nodes.length;

    yield EdgeEvent(
      edges: best.path.toList(),
      event: EdgeEvent.event_replace,
    );

    // Loop until system has cooled
    while (temp >= 1e-10) {
      // Create new neighbour tour
      final newSolution = List.of(currentSolution);

      // Get random positions in the tour
      var tourPos1 = r.nextInt(n);
      var tourPos2 = r.nextInt(n);

      //to make sure that tourPos1 and tourPos2 are different
      while (tourPos1 == tourPos2) {
        tourPos2 = r.nextInt(n);
      }

      // Get the cities at selected positions in the tour
      var citySwap1 = newSolution[tourPos1];
      var citySwap2 = newSolution[tourPos2];

      // Swap them
      newSolution[tourPos2] = citySwap1;
      newSolution[tourPos1] = citySwap2;

      // Get energy of solutions
      var newLen = newSolution.pathLength;

      // Decide if we should accept the neighbour
      if (_acceptanceProbability(currentLen, newLen, temp) >= r.nextDouble()) {
        currentSolution = newSolution;
        currentLen = newLen;
      }

      // Keep track of the best solution found
      if (currentLen < bestLen) {
        best = currentSolution;
        bestLen = currentLen;

        yield EdgeEvent(
          edges: best.path.toList(),
          event: EdgeEvent.event_replace,
        );

        await Future.delayed(Duration(microseconds: 0));
      }

      temp *= (1 - coolingRate);
    }
  }
}

double _acceptanceProbability(
  double currentDistance,
  double newDistance,
  double temperature,
) {
  // If the new solution is better, accept it
  if (newDistance < currentDistance) {
    return 1.0;
  }
  // If the new solution is worse, calculate an acceptance probability
  return exp((currentDistance - newDistance) / temperature);
}
