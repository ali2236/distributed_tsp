import 'dart:async';

import 'package:tsp_base/core.dart';


abstract class Coordinator {
  Future<void> solve(
    Splitter splitter,
    String solverId,
    Connector connector,
    Dataset dataset,
    Map<String, StreamController<Message>> slaves,
  );

}
