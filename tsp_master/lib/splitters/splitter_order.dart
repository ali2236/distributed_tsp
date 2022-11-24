import 'package:tsp_base/src/models/model_node.dart';
import 'package:utility/utility.dart';

import 'splitter.dart';

class OrderSplitter implements Splitter {
  @override
  List<List<Node>> split(List<Node> nodes, int n) {
    return nodes.chunk(n).cast();
  }
}
