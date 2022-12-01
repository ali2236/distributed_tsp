import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:tsp_base/core.dart';

class TspController {
  final Dataset dataset;
  final SlavesService slaveService;
  final Splitter splitter;
  final Connector connector;
  final String solverId;

  TspController({
    required this.dataset,
    required this.slaveService,
    required this.splitter,
    required this.solverId,
    required this.connector,
  });

  void solve() {
    slaveService.startSolving(
      dataset,
      splitter,
      solverId,
      connector,
    );
  }

  void cancel() {
    slaveService.stop();
  }
}
