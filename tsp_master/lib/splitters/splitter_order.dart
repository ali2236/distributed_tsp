import 'package:tsp_base/src/models/model_node.dart';
import 'splitter.dart';

class OrderSplitter implements Splitter {

  const OrderSplitter();

  @override
  List<List<Node>> split(List<Node> nodes, int n) {
    final p = nodes.length ~/ n;
    return List.generate(n, (i) {
      if (i == n) return nodes.sublist(i * p);
      return nodes.sublist(i * p, (i + 1) * p);
    });
  }
}
