import 'dart:async';

import 'package:tsp_base/core.dart';


abstract class Coordinator {
  Future<void> solve(
    Dataset dataset,
    List<Slave> slaves,
  );

}
