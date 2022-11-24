import 'package:tsp_base/core.dart';

class OrderSolver implements Solver {
  @override
  Stream<List<Edge>> solve(Stream<List<Node>> nodes) async* {
    await for(var part in nodes){
      for(var i=0;i<part.length~/2;i+=2){
        final edge = Edge(firstNode: part[i], secondNode: part[i+1]);
        yield [edge];
        await Future.delayed(Duration(milliseconds: 200));
      }
    }
  }

}