import 'package:tsp_base/src/algorithms/solvers/solver_order.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_simulated_annealing.dart';

class SASolver extends SimulatedAnnealingSolver {
  const SASolver()
      : super(
          iterations: 1,
          changeStartEnd: false,
          initialSolver: const OrderSolver(),
        );
}
