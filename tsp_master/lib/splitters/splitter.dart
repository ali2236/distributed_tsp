import 'package:tsp_base/core.dart';

abstract class Splitter {
  List<List<Node>> split(List<Node> nodes, int n);
}
