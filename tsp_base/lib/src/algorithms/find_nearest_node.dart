import 'package:tsp_base/core.dart';

Node findNearestNode(List<Node> nodes, Node v){
  var min = nodes.first;
  var distance = v.distanceFrom(min).abs();
  for(var node in nodes.toList().sublist(1)){
    var nd = v.distanceFrom(node).abs();
    if(nd < distance){
      min = node;
      distance = nd;
    }
  }
  return min;
}