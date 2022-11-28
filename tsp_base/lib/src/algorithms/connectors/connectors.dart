import 'package:tsp_base/src/algorithms/connectors/connector_order.dart';

export 'connector.dart';
export 'connector_order.dart';


const connectors = {
  'By Order' : OrderConnector,
};

final connectorFactories = {
  OrderConnector : () => const OrderConnector(),
};

