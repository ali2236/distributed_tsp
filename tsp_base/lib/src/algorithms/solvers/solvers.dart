import 'package:tsp_base/core.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_exact.dart';

export 'solver.dart';
export 'solver_order.dart';
export 'solver_greedy.dart';

const solvers = {
  'By Order': OrderSolver,
  'Greedy': GreedySolver,
  'Exact' : ExactSolver,
};

final solverFactories = {
  OrderSolver: () => const OrderSolver(),
  GreedySolver: () => const GreedySolver(),
  ExactSolver: () => const ExactSolver(),
};
