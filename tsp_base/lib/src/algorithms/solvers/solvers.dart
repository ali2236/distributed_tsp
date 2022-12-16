import 'package:tsp_base/src/algorithms/solvers/solver_exact.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_greedy.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_nearest_neighbor.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_order.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_sa.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_simulated_annealing.dart';

export 'solver.dart';
export 'solver_order.dart';
export 'solver_nearest_neighbor.dart';
export 'solver_greedy.dart';
export 'solver_simulated_annealing.dart';
export 'solver_sa.dart';

const solvers = {
  'By Order': OrderSolver,
  'Nearest Neighbour': NearestNeighbourSolver,
  'Greedy': GreedySolver,
  'Simulated Annealing' : SimulatedAnnealingSolver,
  'Exact' : ExactSolver,
  'Simulated Annealing*' : SASolver,
};

final solverFactories = {
  OrderSolver: () => const OrderSolver(),
  NearestNeighbourSolver: () => const NearestNeighbourSolver(),
  ExactSolver: () => const ExactSolver(),
  GreedySolver: () => const GreedySolver(),
  SimulatedAnnealingSolver : () => const SimulatedAnnealingSolver(),
  SASolver : () => const SASolver(),
};
