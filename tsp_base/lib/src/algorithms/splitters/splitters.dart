import 'package:tsp_base/src/algorithms/splitters/splitter_kmeans.dart';
import 'package:tsp_base/src/algorithms/splitters/splitter_order.dart';

export 'splitter.dart';
export 'splitter_order.dart';
export 'splitter_kmeans.dart';

const splitters = {
  'By Order' : OrderSplitter,
  'KMeans' : KMeansSplitter,
};

final splitterFactories = {
  OrderSplitter : () => const OrderSplitter(),
  KMeansSplitter : () => const KMeansSplitter(),
};