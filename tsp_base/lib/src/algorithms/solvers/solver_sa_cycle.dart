import 'package:tsp_base/src/algorithms/solvers/solver_order.dart';
import 'package:tsp_base/src/algorithms/solvers/solver_simulated_annealing.dart';

class SACycleSolver extends SimulatedAnnealingSolver {
  const SACycleSolver()
      : super(
          cycle: true,
          changeStartEnd: true,
        );
}
