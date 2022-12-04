import 'dart:math';

import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/extensions/extension_nodes.dart';
import 'package:tsp_base/src/models/model_edge_event.dart';
import 'package:tsp_base/src/models/model_node.dart';

class SimulatedAnnealingSolver implements Solver {
  const SimulatedAnnealingSolver();

  @override
  Stream<EdgeEvent> solve(List<Node> nodes, Stream<EdgeEvent> sync) async* {
    double temp = 1000000000.0;
    double coolingRate = 0.00001;
    var currentSolution = List.of(nodes);
    var best = currentSolution;
    final r = Random();
    final n = nodes.length;

    yield EdgeEvent(
      edges: best.path.toList(),
      event: EdgeEvent.event_add,
    );

    // Loop until system has cooled
    while (temp > 1) {
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
      var currentDistance = currentSolution.pathLength;
      var neighbourDistance = newSolution.pathLength;

      // Decide if we should accept the neighbour
      if (_acceptanceProbability(currentDistance, neighbourDistance, temp) >
          r.nextDouble()) {
        currentSolution = newSolution;
      }

      // Keep track of the best solution found
      if (currentSolution.pathLength < best.pathLength) {
        best = currentSolution;

        yield EdgeEvent(
          edges: best.path.toList(),
          event: EdgeEvent.event_replace,
        );
      }

      // Cool system
      temp *= 1 - coolingRate;
    }

    print('best dst: ${best.pathLength}');
    /*yield EdgeEvent(
      edges: best.path.toList(),
      event: EdgeEvent.event_clear,
    );
    yield EdgeEvent(
      edges: best.path.toList(),
      event: EdgeEvent.event_add,
    );*/

    yield EdgeEvent.done();
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
