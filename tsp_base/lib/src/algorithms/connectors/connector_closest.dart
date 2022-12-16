import 'package:tsp_base/src/models/model_edge.dart';
import 'package:tsp_base/src/models/model_node.dart';

class ClosestConnector {
  Edge connect(List<Node> p1, List<Node> p2) {
    var min = Edge(firstNode: p1.first, secondNode: p2.first);
    for(var i=1;i<p1.length;i++){
      for(var j=1;j<p2.length;j++){
        final edge = Edge(firstNode: p1[i], secondNode: p2[j]);
        if(edge.length < min.length){
          min = edge;
        }
      }
    }
    return min;
  }
}
