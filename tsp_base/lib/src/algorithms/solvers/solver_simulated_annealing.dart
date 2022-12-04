import 'dart:math';

import 'package:tsp_base/src/algorithms/solvers/solver.dart';
import 'package:tsp_base/src/models/extensions/extension_nodes.dart';
import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

class SimulatedAnnealingSolver implements Solver {

  const SimulatedAnnealingSolver();

  @override
  Stream<List<Edge>> solve(List<Node> nodes, void Function() onFinish) async* {
    //Set initial temp
    double temp = 100000.0;

    //Cooling rate
    double coolingRate = 0.001;

    final n = nodes.length;

    //create random intial solution
    var currentSolution = _Tour(nodes);
    currentSolution.generateIndividual();

    // We would like to keep track if the best solution
    // Assume best solution is the current solution
    var best = _Tour.from(nodes, currentSolution.tour);

    final r = Random();

    // Loop until system has cooled
    while (temp > 1) {
      // Create new neighbour tour
      final newSolution = _Tour.from(nodes, currentSolution.tour);

      // Get random positions in the tour
      int tourPos1 = r.nextInt(newSolution.tourSize());
      int tourPos2 = r.nextInt(newSolution.tourSize());

      //to make sure that tourPos1 and tourPos2 are different
      while (tourPos1 == tourPos2) {
        tourPos2 = r.nextInt(newSolution.tourSize());
      }

      // Get the cities at selected positions in the tour
      var citySwap1 = newSolution.getCity(tourPos1);
      var citySwap2 = newSolution.getCity(tourPos2);

      // Swap them
      newSolution.setCity(tourPos2, citySwap1);
      newSolution.setCity(tourPos1, citySwap2);

      // Get energy of solutions
      var currentDistance = currentSolution.getTotalDistance();
      var neighbourDistance = newSolution.getTotalDistance();

      // Decide if we should accept the neighbour
      double rand = r.nextDouble();
      if (_acceptanceProbability(currentDistance, neighbourDistance, temp) >
          rand) {
        currentSolution = _Tour.from(nodes, newSolution.tour);
      }

      // Keep track of the best solution found
      if (currentSolution.getTotalDistance() < best.getTotalDistance()) {
        best = _Tour.from(nodes, currentSolution.tour);
      }

      // Cool system
      temp *= 1 - coolingRate;
    }

    print('best dst: ${best.getTotalDistance()}');
    yield best.tour.path.toList();

    onFinish();
  }
}

class _Tour {
  final List<Node> nodes;
  var tour = <Node>[];
  var distance = 0.0;

  _Tour(this.nodes){
    tour = List.generate(nodes.length, (i) => Node(-1, -1));
  }

  factory _Tour.from(List<Node> nodes, List<Node> tour) {
    final t = _Tour(nodes);
    t.tour = List.of(tour);
    return t;
  }

  void generateIndividual() {
    // Loop through all our destination cities and add them to our tour
    for (var cityIndex = 0; cityIndex < nodes.length; cityIndex++) {
      setCity(cityIndex, nodes[cityIndex]);
    }
    // Randomly reorder the tour
    tour.shuffle();
  }

  Node getCity(int index) {
    return tour[index];
  }

  void setCity(int index, Node city) {
    tour[index] = city;
    // If the tour has been altered we need to reset the fitness and distance
    distance = 0;
  }

  double getTotalDistance() {
    if (distance == 0) {
      var tourDistance = 0.0;
      // Loop through our tour's cities
      for (int cityIndex = 0; cityIndex < tourSize(); cityIndex++) {
        // Get city we're traveling from
        final fromCity = getCity(cityIndex);
        // City we're traveling to
        late Node destinationCity;
        // Check we're not on our tour's last city, if we are set our
        // tour's final destination city to our starting city
        if (cityIndex + 1 < tourSize()) {
          destinationCity = getCity(cityIndex + 1);
        } else {
          destinationCity = getCity(0);
        }
        // Get the distance between the two cities
        tourDistance +=
            Edge(firstNode: fromCity, secondNode: destinationCity).length;
      }
      distance = tourDistance;
    }
    return distance;
  }

  int tourSize() {
    return tour.length;
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
