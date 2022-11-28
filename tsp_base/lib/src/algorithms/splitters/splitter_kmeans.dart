import 'package:tsp_base/src/models/model_node.dart';
import 'package:kmeans/kmeans.dart';
import 'splitter.dart';

class KMeansSplitter implements Splitter {

  const KMeansSplitter();

  @override
  List<List<Node>> split(List<Node> nodes, int n) {
    final kmeans = KMeans(nodes.map((v) => [v.x, v.y]).toList());
    final clusters = kmeans.fit(n, maxIterations: 10);
    final partitions = clusters.clusterPoints
        .map((c) => c.map((v) => Node(v[0], v[1])).toList())
        .toList();
    return partitions;
  }
}
