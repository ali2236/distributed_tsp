import 'package:tsp_base/core.dart';

class NonConnector extends Connector {

  const NonConnector();

  @override
  Set<Edge> connect(Dataset dataset) {
    return {};
  }

}