import 'package:tsp_base/src/algorithms/connectors/connector_greedy.dart';
import 'package:tsp_base/src/algorithms/connectors/connector_order.dart';

export 'connector.dart';
export 'connector_order.dart';
export 'connector_greedy.dart';


const connectors = {
  'By Order' : OrderConnector,
  'Greedy' : GreedyConnector,
};

final connectorFactories = {
  OrderConnector : () => const OrderConnector(),
  GreedyConnector : () => const GreedyConnector(),
};

