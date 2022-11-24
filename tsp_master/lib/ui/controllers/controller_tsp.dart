

import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:destributed_tsp/splitters/splitter_order.dart';
import 'package:tsp_base/core.dart';

class TspController {
  final Dataset dataset;
  final SlavesService slaveService;

  TspController({
    required this.dataset,
    required this.slaveService,
  });

  void solve() {
    slaveService.startSolving(dataset, OrderSplitter());
  }
}
