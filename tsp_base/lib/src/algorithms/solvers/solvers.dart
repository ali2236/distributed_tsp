import 'package:tsp_base/core.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_exact.dart';

export 'solver.dart';
export 'solver_order.dart';
export 'solver_nearest_neighbor.dart';
export 'solver_greedy.dart';
export 'solver_simulated_annealing.dart';

const solvers = {
  'By Order': OrderSolver,
  'Nearest Neighbour': NearestNeighbourSolver,
  'Greedy': GreedySolver,
  'Simulated Annealing' : SimulatedAnnealingSolver,
  'Exact' : ExactSolver,
};

final solverFactories = {
  OrderSolver: () => const OrderSolver(),
  NearestNeighbourSolver: () => const NearestNeighbourSolver(),
  ExactSolver: () => const ExactSolver(),
  GreedySolver: () => const GreedySolver(),
  SimulatedAnnealingSolver : () => const SimulatedAnnealingSolver(),
};
