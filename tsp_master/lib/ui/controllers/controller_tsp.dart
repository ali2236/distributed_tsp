import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:tsp_base/core.dart';

class TspController {
  final Dataset dataset;
  final SlavesService slaveService;
  final Coordinator coordinator;

  TspController({
    required this.dataset,
    required this.slaveService,
    required this.coordinator,
  });

  void solve() {
    slaveService.startSolving(
      coordinator,
      dataset,
    );
  }

  void cancel() {
    slaveService.restart();
  }
}
