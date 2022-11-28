import 'package:destributed_tsp/services/service_slaves.dart';
import 'package:get/get.dart';
import 'package:tsp_base/core.dart';


class TspController {
  final Dataset dataset;
  final SlavesService slaveService;

  TspController({
    required this.dataset,
    required this.slaveService,
  });

  void solve() {
    slaveService.startSolving(
      dataset,
      Get.find(),
      Get.find(tag: 'solver'),
      Get.find(),
    );
  }

  void cancel(){
    slaveService.stop();
  }
}
