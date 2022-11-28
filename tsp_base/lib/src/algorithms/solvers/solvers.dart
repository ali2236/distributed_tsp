import 'package:tsp_base/core.dart';

export 'solver.dart';
export 'solver_order.dart';
export 'solver_greedy.dart';

const solvers = {
  'By Order': OrderSolver,
  'Greedy': GreedySolver,
};

final solverFactories = {
  OrderSolver: () => const OrderSolver(),
  GreedySolver: () => const GreedySolver(),
};
