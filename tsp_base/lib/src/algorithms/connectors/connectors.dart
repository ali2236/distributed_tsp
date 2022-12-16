import 'package:tsp_base/src/algorithms/connectors/connector_greedy.dart';
import 'package:tsp_base/src/algorithms/connectors/connector_none.dart';
import 'package:tsp_base/src/algorithms/connectors/connector_order.dart';

export 'connector.dart';
export 'connector_order.dart';
export 'connector_greedy.dart';
export 'connector_none.dart';
export 'connector_closest.dart';

const connectors = {
  'By Order': OrderConnector,
  'Greedy': GreedyConnector,
  'None': NonConnector,
};

final connectorFactories = {
  OrderConnector: () => const OrderConnector(),
  GreedyConnector: () => const GreedyConnector(),
  NonConnector: () => const NonConnector(),
};
